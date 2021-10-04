import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

import '../components/already_have_an_account_check.dart';
import '../../../services/auth_base.dart';
import '../../../app/screens/email_sign_up_screen.dart';
import '../../../layout/custom_text_style.dart';
import '../../../common_widgets/true_or_false_switch.dart';
import '../../../app/screens/email_verification_screen.dart';
import '../../../common_widgets/custom_icon_text_field.dart';
import '../../../app/sign_in/components/password_field.dart';
import '../../../app/sign_in/components/forgot_password.dart';
import '../../../models_and_managers/managers/email_sign_in_view_model.dart';
import '../../../common_widgets/cancel_and_sign_in_buttons.dart';
import '../../../common_widgets/platform_exception_alert_dialog.dart';

class EmailSignInFormChangeNotifierBased extends StatefulWidget {
  final EmailSignInViewModel model;
  const EmailSignInFormChangeNotifierBased({
    Key key,
    this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<EmailSignInViewModel>(
      create: (_) => EmailSignInViewModel(),
      child: Consumer<EmailSignInViewModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifierBased(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierBasedState createState() =>
      _EmailSignInFormChangeNotifierBasedState();
}

class _EmailSignInFormChangeNotifierBasedState
    extends State<EmailSignInFormChangeNotifierBased> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  FocusNode _emailNode, _signInButtonNode, _passwordNode;
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    _signInButtonNode = FocusNode();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _signInButtonNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordNode);
  }

  void _passwordEditingComplete() {
    FocusScope.of(context).requestFocus(_signInButtonNode);
  }

  EmailSignInViewModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Consumer<TrueOrFalseSwitch>(
      builder: (context, _onSwitch, child) => Container(
        height: MediaQuery.of(context).size.height / 1.05,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(context, _onSwitch),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(
      BuildContext context, TrueOrFalseSwitch _onSwitch) {
    double size = MediaQuery.of(context).size.height;
    return [
      Center(
        child: Column(
          children: [
            SizedBox(
              height: size * 0.2,
            ),
            Text(
              'Welcome back!',
              style: CustomTextStyles.textStyleTitle(fontSize: 25),
            ),
            Text(
              "We're so excited to see you again!",
              style: CustomTextStyles.textStyleBold(fontSize: 13),
            ),
          ],
        ),
      ),
      SizedBox(
        height: size * 0.1,
      ),
      AlreadyHaveAnAccountCheck(
        isMember: false,
        press: _onSwitch.value ? null : _routeToSignUp,
      ),
      _buildInputFields(context, _onSwitch.value),
      Align(
        alignment: Alignment.centerRight,
        child: _onSwitch.value
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: size * 0.028,
                  width: size * 0.028,
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                ),
              )
            : ForgotPassword(
                press: () async {
                  if (_emailKey.currentState.validate()) {
                    _onSwitch.toggle();
                    await model
                        .forgetPassword(
                          context: context,
                          email: _emailController.text,
                        )
                        .whenComplete(() => _onSwitch.toggle());
                  }
                },
              ),
      ),
      CancelAndSignInButtons(
        focusNode: _signInButtonNode,
        text: 'SIGN IN',
        onPressed: _onSwitch.value ? null : _submit,
      ),
    ];
  }

  Widget _buildInputFields(BuildContext context, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEmail(isLoading),
            SizedBox(height: size.height * 0.02),
            _buildPassword(isLoading),
          ],
        ),
      ),
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateAndSaveEmailField() {
    final emailField = _emailKey.currentState;
    if (emailField.validate()) {
      emailField.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    ProgressDialog progressDialog = ProgressDialog(
      context: (context),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Signing you in...',
    );
    if (_validateAndSaveForm() && _validateAndSaveEmailField()) {
      progressDialog.show();
      try {
        await model
            .submit(context)
            .whenComplete(() => progressDialog.dismiss());
        final isUserVerified = auth.isUserVerified();
        if (isUserVerified) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) =>
                  EmailVerificationPage(_emailController.text),
            ),
          );
        }
      } on PlatformException catch (e) {
        progressDialog.dismiss();
        PlatformExceptionAlertDialog(
          title: 'Sign in Failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _routeToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EmailSignUpPage();
        },
      ),
    );
  }

  Widget _buildEmail(bool isLoading) {
    return Form(
      key: _emailKey,
      child: CustomIconTextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSaved: (email) => model.updateWith(email: email),
        validator: model.emailValidator,
        focusNode: _emailNode,
        icon: Icons.email,
        labelText: 'Email',
        enabled: !isLoading,
        onEditingComplete: _emailEditingComplete,
      ),
    );
  }

  Widget _buildPassword(bool isLoading) {
    return PasswordField(
      focusNode: _passwordNode,
      labelText: 'Password',
      validator: model.requiredValidator,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      passwordController: _passwordController,
      onSaved: (password) => model.updateWith(password: password),
      enabled: !isLoading,
      onEditingComplete: _passwordEditingComplete,
    );
  }
}
