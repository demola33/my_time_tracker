import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

import '../components/already_have_an_account_check.dart';
import '../../../common_widgets/platform_exception_alert_dialog.dart';
import '../../../common_widgets/cancel_and_sign_in_buttons.dart';
import '../../../models_and_managers/models/email_sign_up_model.dart';
import '../../../app/screens/email_verification_screen.dart';
import '../../../app/sign_in/components/password_field.dart';
import '../../../common_widgets/custom_icon_text_field.dart';
import '../../../app/screens/email_sign_in_screen.dart';

class EmailSignUpFormChangeNotifierBased extends StatefulWidget {
  final EmailSignUpModel model;

  EmailSignUpFormChangeNotifierBased({
    Key key,
    this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<EmailSignUpModel>(
      create: (_) => EmailSignUpModel(),
      child: Consumer<EmailSignUpModel>(
        builder: (context, model, _) => EmailSignUpFormChangeNotifierBased(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignUpFormChangeNotifierBasedState createState() =>
      _EmailSignUpFormChangeNotifierBasedState();
}

class _EmailSignUpFormChangeNotifierBasedState
    extends State<EmailSignUpFormChangeNotifierBased> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _EmailSignUpFormChangeNotifierBasedState({this.onChanged});
  final _formKey = GlobalKey<FormState>();

  final ValueChanged<bool> onChanged;
  EmailSignUpModel get model => widget.model;

  FocusNode _firstNameNode,
      _lastNameNode,
      _emailNode,
      _passwordNode,
      _retypePasswordNode,
      _signUpButtonNode;

  @override
  void initState() {
    super.initState();
    _firstNameNode = FocusNode();
    _emailNode = FocusNode();
    _lastNameNode = FocusNode();
    _passwordNode = FocusNode();
    _retypePasswordNode = FocusNode();
    _signUpButtonNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameNode.dispose();
    _emailNode.dispose();
    _lastNameNode.dispose();
    _passwordNode.dispose();
    _retypePasswordNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _firstNameEditingComplete() {
    FocusScope.of(context).requestFocus(_lastNameNode);
  }

  void _lastNameEditingComplete() {
    FocusScope.of(context).requestFocus(_emailNode);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordNode);
  }

  _passwordEditingComplete() {
    FocusScope.of(context).requestFocus(_retypePasswordNode);
  }

  _confirmPasswordEditingComplete() {
    FocusScope.of(context).requestFocus(_signUpButtonNode);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: model.submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    Size size = MediaQuery.of(context).size;
    return [
      SizedBox(height: size.height * 0.1),
      AlreadyHaveAnAccountCheck(
        isMember: true,
        press: _routeToSignIn,
      ),
      _buildFirstName(),
      SizedBox(height: size.height * 0.02),
      _buildLastName(),
      SizedBox(height: size.height * 0.02),
      _buildEmail(),
      SizedBox(height: size.height * 0.02),
      _buildPassword(),
      SizedBox(height: size.height * 0.02),
      _buildConfirmPassword(),
      CancelAndSignInButtons(
        focusNode: _signUpButtonNode,
        text: 'SIGN UP',
        onPressed: _submit,
      ),
    ];
  }

  Widget _buildFirstName() {
    return CustomIconTextField(
      focusNode: _firstNameNode,
      controller: _firstNameController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onSaved: (firstName) => model.updateWith(firstName: firstName),
      onEditingComplete: _firstNameEditingComplete,
      validator: model.firstNameValidator,
      icon: Icons.person,
      labelText: 'First Name',
      hint: 'Adam',
    );
  }

  Widget _buildLastName() {
    return CustomIconTextField(
      focusNode: _lastNameNode,
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onSaved: (lastName) => model.updateWith(lastName: lastName),
      onEditingComplete: _lastNameEditingComplete,
      validator: model.lastNameValidator,
      icon: Icons.person,
      labelText: 'Last Name',
      hint: 'Smith',
    );
  }

  Widget _buildEmail() {
    return CustomIconTextField(
      focusNode: _emailNode,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (email) => model.updateWith(email: email),
      onEditingComplete: _emailEditingComplete,
      labelText: 'Email',
      hint: 'adamsmith@email.com',
      icon: Icons.email,
      validator: model.emailValidator,
    );
  }

  Widget _buildPassword() {
    return PasswordField(
      focusNode: _passwordNode,
      labelText: 'Password',
      validator: model.passValidator,
      passwordController: _passwordController,
      onChanged: (password) => model.updateWith(password: password),
      textInputAction: TextInputAction.next,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildConfirmPassword() {
    return PasswordField(
      focusNode: _retypePasswordNode,
      labelText: 'Confirm Password',
      passwordController: _confirmPasswordController,
      textInputAction: TextInputAction.next,
      validator: (value) => model.passwordMatchValidator(value),
      onChanged: (password) => model.updateWith(confirmPassword: password),
      onEditingComplete: _confirmPasswordEditingComplete,
    );
  }

  Future<void> _routeToSignIn() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) {
          return EmailSignInPage();
        },
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

  Future<void> _submit() async {
    model.updateWith(submitted: true);
    ProgressDialog progressDialog = ProgressDialog(
      context: (context),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Signing you up...',
    );

    if (_validateAndSaveForm()) {
      progressDialog.show();
      try {
        await model
            .submit(context)
            .whenComplete(() => progressDialog.dismiss());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => EmailVerificationPage(_emailController.text),
          ),
        );
      } on PlatformException catch (e) {
        print('ERROR Code: ${e.code}');
        progressDialog.dismiss();
        PlatformExceptionAlertDialog(
          title: 'Sign in Failed',
          exception: e,
        ).show(context);
      }
    }
  }
}
