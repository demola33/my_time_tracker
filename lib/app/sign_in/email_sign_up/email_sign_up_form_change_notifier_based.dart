import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_in/email_sign_in_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_up/email_sign_up_model.dart';
import 'package:my_time_tracker/common_widgets/custom_back_button.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import '../components/already_have_an_account_check.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:my_time_tracker/common_widgets/firebase_auth_exception_alert_dialog.dart';

class EmailSignUpFormChangeNotifierBased extends StatefulWidget {
  final EmailSignUpModel model;

  EmailSignUpFormChangeNotifierBased({
    Key key,
    this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignUpModel>(
      create: (_) => EmailSignUpModel(auth: auth),
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

  final ValueChanged<bool> onChanged;
  EmailSignUpModel get model => widget.model;

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
      _buildFirstName(),
      SizedBox(height: size.height * 0.01),
      _buildLastName(),
      SizedBox(height: size.height * 0.01),
      _buildEmail(),
      SizedBox(height: size.height * 0.01),
      _buildPassword(),
      SizedBox(height: size.height * 0.02),
      _buildConfirmPassword(),
      _checkboxListTile(),
      FormSubmitButton(
        text: 'Sign Up',
        onPressed: model.canSubmit && model.agree ? _submit : null,
      ),
      SizedBox(height: size.height * 0.03),
      AlreadyHaveAnAccountCheck(
        isMember: true,
        press: _routeToSignIn,
      ),
      SizedBox(height: size.height * 0.03),
      Row(
        children: [CustomBackButton()],
      ),
    ];
  }

  Widget _buildFirstName() {
    return TextFormField(
      controller: _firstNameController,
      decoration: _buildInputDecoration('First Name', 'Adam', Icons.person,
          null, model.firstNameErrorText, model),
      enableSuggestions: false,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (firstName) => model.updateWith(firstName: firstName),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      controller: _lastNameController,
      decoration: _buildInputDecoration('Last Name', 'Smith', Icons.person,
          null, model.lastNameErrorText, model),
      enableSuggestions: false,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (lastName) => model.updateWith(lastName: lastName),
    );
  }

  Widget _buildEmail() {
    return TextField(
      controller: _emailController,
      decoration: _buildInputDecoration('Email', 'adamsmith@email.com',
          Icons.email, null, model.emailErrorText, model),
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      textInputAction: TextInputAction.next,
      onChanged: (email) => model.updateWith(email: email),
    );
  }

  Widget _buildPassword() {
    return TextField(
      controller: _passwordController,
      decoration: _buildInputDecoration('Password', null, Icons.lock,
          Icons.visibility, model.passwordErrorText, model),
      obscureText: true,
      textInputAction: TextInputAction.next,
      onChanged: (password) => model.updateWith(password: password),
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: _buildInputDecoration('Confirm Password', null, Icons.lock,
          Icons.visibility, model.confirmPasswordErrorText, model),
      obscureText: true,
      onChanged: (password) => model.updateWith(confirmPassword: password),
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

  CheckboxListTile _checkboxListTile() {
    Size size = MediaQuery.of(context).size;
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: model.agree,
      onChanged: (bool newValue) {
        model.updateWith(agree: newValue);
      },
      title: Text(
        'Agree to terms and conditions',
        style: TextStyle(
          fontFamily: 'SourceSansPro',
          fontSize: size.height * 0.025,
          fontWeight: FontWeight.bold,
          color: Colors.teal[900],
        ),
      ),
    );
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

  InputDecoration _buildInputDecoration(
    String labelText,
    String hint,
    IconData icon,
    IconData suffixIcon,
    String errorText,
    EmailSignUpModel model,
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
      enabled: model.isLoading == false,
    );
  }
}
