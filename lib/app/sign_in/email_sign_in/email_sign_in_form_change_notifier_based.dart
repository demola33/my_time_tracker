import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_up/email_sign_up_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_in/email_sign_in_model.dart';
import 'package:my_time_tracker/common_widgets/custom_back_button.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/firebase_auth_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import '../components/already_have_an_account_check.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

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
      showSpinner(),
      SizedBox(height: size.height * 0.06),
      _buildEmail(),
      SizedBox(height: size.height * 0.01),
      _buildPassword(),
      SizedBox(height: size.height * 0.02),
      FormSubmitButton(
        text: 'Sign in',
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: size.height * 0.03),
      AlreadyHaveAnAccountCheck(
        isMember: false,
        press: _routeToSignUp,
      ),
      Row(
        children: [CustomBackButton()],
      )
    ];
  }

  Widget showSpinner() {
    if (model.isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
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

  InputDecoration _buildInputDecoration(
    String labelText,
    String errorText,
    String hint,
    IconData icon,
    bool value,
    IconData suffixIcon,
  ) {
    Size size = MediaQuery.of(context).size;
    return InputDecoration(
      labelText: labelText,
      hintText: hint,
      labelStyle: TextStyle(
        fontFamily: 'SourceSansPro',
        fontWeight: FontWeight.bold,
        fontSize: size.height * 0.025,
      ),
      icon: Icon(
        icon,
        color: Colors.teal[700],
        size: size.height * 0.05,
      ),
      suffixIcon: Icon(
        suffixIcon,
        color: Colors.teal[700],
      ),
      errorText: errorText,
      enabled: value,
    );
  }

  Widget _buildEmail() {
    return TextField(
      controller: _emailController,
      decoration: _buildInputDecoration(
        'Email',
        model.emailErrorText,
        'smith@email.com',
        Icons.email,
        model.isLoading == false,
        null,
      ),
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      textInputAction: TextInputAction.next,
      onChanged: (email) => model.updateWith(email: email),
    );
  }

  Widget _buildPassword() {
    return TextField(
      controller: _passwordController,
      decoration: _buildInputDecoration('Password', model.passwordErrorText,
          null, Icons.lock, model.isLoading == false, Icons.visibility),
      obscureText: true,
      onEditingComplete: _submit,
      onChanged: (password) => model.updateWith(password: password),
    );
  }
}
