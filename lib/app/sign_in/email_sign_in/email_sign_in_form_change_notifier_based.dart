import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

import 'package:my_time_tracker/app/sign_in/components/email_and_name_text_field.dart';
import 'package:my_time_tracker/app/sign_in/components/password_field.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_up/email_sign_up_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_in/email_sign_in_model.dart';
import 'package:my_time_tracker/common_widgets/cancel_and_next_button.dart';
import 'package:my_time_tracker/common_widgets/firebase_auth_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import '../components/already_have_an_account_check.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    Size size = MediaQuery.of(context).size;
    return [
      SizedBox(height: size.height * 0.45),
      showProgressIndicator(),
      SizedBox(height: size.height * 0.015),
      _buildEmail(),
      SizedBox(height: size.height * 0.01),
      _buildPassword(),
      SizedBox(height: size.height * 0.02),
      CancelAndSignInButtons(
        focusNode: _signInButtonNode,
        text: 'SIGN IN',
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: size.height * 0.01),
      AlreadyHaveAnAccountCheck(
        isMember: false,
        press: _routeToSignUp,
      ),
    ];
  }

  Widget showProgressIndicator() {
    if (model.isLoading == true) {
      return Center(
        child: LinearProgressIndicator(),
      );
    } else {
      return Container();
    }
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      FirebaseAuthExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
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
    return EmailNameSignInTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      //enableSuggestions: false,
      textInputAction: TextInputAction.next,
      onChanged: (email) => model.updateWith(email: email),
      errorText: model.emailErrorText,
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
      reTypePassword: false,
      errorText: model.passwordErrorText,
      textInputAction: TextInputAction.next,
      passwordController: _passwordController,
      onChanged: (password) => model.updateWith(password: password),
      enabled: model.isLoading == false,
      onEditingComplete: _passwordEditingComplete,
    );
  }
}
