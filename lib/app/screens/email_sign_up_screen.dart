import 'package:flutter/material.dart';
import '../sign_in/email_sign_up/email_sign_up_form_change_notifier_based.dart';

class EmailSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 173, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EmailSignUpFormChangeNotifierBased.create(context),
        ),
      ),
    );
  }
}
