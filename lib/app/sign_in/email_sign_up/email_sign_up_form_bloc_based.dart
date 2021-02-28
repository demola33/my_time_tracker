import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_in/email_sign_in_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_up/email_sign_up_bloc.dart';
import 'package:my_time_tracker/blocs/email_sign_up/email_sign_up_model.dart';
import 'package:my_time_tracker/common_widgets/custom_back_button.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import '../components/already_have_an_account_check.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';

class EmailSignUpFormBlocBased extends StatefulWidget {
  final EmailSignUpBloc bloc;

  EmailSignUpFormBlocBased({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignUpBloc>(
      create: (_) => EmailSignUpBloc(auth: auth),
      child: Consumer<EmailSignUpBloc>(
        builder: (context, bloc, _) => EmailSignUpFormBlocBased(
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  _EmailSignUpFormBlocBasedState createState() =>
      _EmailSignUpFormBlocBasedState();
}

class _EmailSignUpFormBlocBasedState extends State<EmailSignUpFormBlocBased> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _EmailSignUpFormBlocBasedState({this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<EmailSignUpModel>(
          stream: widget.bloc.modelSignUpStream,
          initialData: EmailSignUpModel(),
          builder: (context, snapshot) {
            EmailSignUpModel model = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(context, model),
              ),
            );
          }),
    );
  }

  List<Widget> _buildChildren(context, EmailSignUpModel model) {
    Size size = MediaQuery.of(context).size;

    return [
      _buildFirstName(model),
      SizedBox(height: size.height * 0.01),
      _buildLastName(model),
      SizedBox(height: size.height * 0.01),
      _buildEmail(model),
      SizedBox(height: size.height * 0.01),
      _buildPassword(model),
      SizedBox(height: size.height * 0.02),
      _buildConfirmPassword(model),
      _checkboxListTile(model),
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

  Widget _buildFirstName(EmailSignUpModel model) {
    return TextFormField(
      controller: _firstNameController,
      decoration: _buildInputDecoration('First Name', 'Adam', Icons.person,
          null, model.firstNameErrorText, model),
      enableSuggestions: false,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (firstName) => widget.bloc.updateWith(firstName: firstName),
    );
  }

  Widget _buildLastName(EmailSignUpModel model) {
    return TextFormField(
      controller: _lastNameController,
      decoration: _buildInputDecoration('Last Name', 'Smith', Icons.person,
          null, model.lastNameErrorText, model),
      enableSuggestions: false,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (lastName) => widget.bloc.updateWith(lastName: lastName),
    );
  }

  Widget _buildEmail(EmailSignUpModel model) {
    return TextField(
      controller: _emailController,
      decoration: _buildInputDecoration('Email', 'adamsmith@email.com',
          Icons.email, null, model.emailErrorText, model),
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      textInputAction: TextInputAction.next,
      onChanged: (email) => widget.bloc.updateWith(email: email),
    );
  }

  Widget _buildPassword(EmailSignUpModel model) {
    return TextField(
      controller: _passwordController,
      decoration: _buildInputDecoration('Password', null, Icons.lock,
          Icons.visibility, model.passwordErrorText, model),
      obscureText: true,
      textInputAction: TextInputAction.next,
      onChanged: (password) => widget.bloc.updateWith(password: password),
    );
  }

  Widget _buildConfirmPassword(EmailSignUpModel model) {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: _buildInputDecoration('Confirm Password', null, Icons.lock,
          Icons.visibility, model.confirmPasswordErrorText, model),
      obscureText: true,
      onChanged: (password) =>
          widget.bloc.updateWith(confirmPassword: password),
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

  CheckboxListTile _checkboxListTile(EmailSignUpModel model) {
    Size size = MediaQuery.of(context).size;
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: model.agree,
      onChanged: (bool newValue) {
        widget.bloc.updateWith(agree: newValue);
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

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
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
