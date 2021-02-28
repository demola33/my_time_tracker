import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_up/email_sign_up_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_in/email_sign_in_bloc.dart';
import 'package:my_time_tracker/blocs/email_sign_in/email_sign_in_model.dart';
import 'package:my_time_tracker/common_widgets/custom_back_button.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import '../components/already_have_an_account_check.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  final EmailSignInBloc bloc;
  EmailSignInFormBlocBased({
    Key key,
    this.bloc,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<EmailSignInModel>(
          stream: widget.bloc.modelSignInStream,
          initialData: EmailSignInModel(),
          builder: (context, snapshot) {
            final EmailSignInModel model = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(model),
              ),
            );
          }),
    );
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    Size size = MediaQuery.of(context).size;
    return [
      showSpinner(model),
      SizedBox(height: size.height * 0.06),
      _buildEmail(model),
      SizedBox(height: size.height * 0.01),
      _buildPassword(model),
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

  Widget showSpinner(EmailSignInModel model) {
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
      await widget.bloc.submit();
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

  Widget _buildEmail(EmailSignInModel model) {
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
      onChanged: (email) => widget.bloc.updateWith(email: email),
    );
  }

  Widget _buildPassword(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      decoration: _buildInputDecoration('Password', model.passwordErrorText,
          null, Icons.lock, model.isLoading == false, Icons.visibility),
      obscureText: true,
      onEditingComplete: _submit,
      onChanged: (password) => widget.bloc.updateWith(password: password),
    );
  }
}
