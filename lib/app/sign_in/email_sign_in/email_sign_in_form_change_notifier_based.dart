import 'package:flutter/services.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:my_time_tracker/app/sign_in/components/forgot_password.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/custom_icon_text_field.dart';
import 'package:my_time_tracker/app/sign_in/components/password_field.dart';
import 'package:my_time_tracker/app/screens/email_sign_up_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_in/email_sign_in_model.dart';
import 'package:my_time_tracker/common_widgets/cancel_and_sign_in_buttons.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import '../components/already_have_an_account_check.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInFormChangeNotifierBased extends StatefulWidget {
  final EmailSignInModel model;
  EmailSignInFormChangeNotifierBased({
    Key key,
    this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (_) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
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
    super.dispose();
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordNode);
  }

  void _passwordEditingComplete() {
    FocusScope.of(context).requestFocus(_signInButtonNode);
  }

  EmailSignInModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.05,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return [
      SizedBox(
        height: size.height * 0.3,
      ),
      AlreadyHaveAnAccountCheck(
        isMember: false,
        press: _routeToSignUp,
      ),
      _buildInputFields(size),
      Align(
        alignment: Alignment.centerRight,
        child: ForgotPassword(
          press: () {},
        ),
      ),
      CancelAndSignInButtons(
        focusNode: _signInButtonNode,
        text: 'SIGN IN',
        onPressed: _submit,
      ),
    ];
  }

  Widget _buildInputFields(Size size) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              _buildEmail(),
              SizedBox(height: size.height * 0.02),
              _buildPassword(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    ProgressDialog progressDialog = ProgressDialog(
      context: (context),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Signing you in...',
    );
    if (_formKey.currentState.validate()) {
      progressDialog.show();
      try {
        await model.submit();
        Navigator.popUntil(context, (route) => route.isFirst);
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
          return EmailSignUpPage();
        },
      ),
    );
  }

  Widget _buildEmail() {
    return CustomIconTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => model.updateWith(email: email),
      validator: model.emailValidator,
      focusNode: _emailNode,
      icon: Icons.email,
      labelText: 'Email',
      enabled: model.isLoading == false,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Widget _buildPassword() {
    return PasswordField(
      focusNode: _passwordNode,
      labelText: 'Password',
      validator: model.requiredValidator,
      textInputAction: TextInputAction.next,
      passwordController: _passwordController,
      onChanged: (password) => model.updateWith(password: password),
      enabled: model.isLoading == false,
      onEditingComplete: _passwordEditingComplete,
    );
  }
}
