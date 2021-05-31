import 'package:flutter/material.dart';
import 'email_sign_up_form_change_notifier_based.dart';

class EmailSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EmailSignUpFormChangeNotifierBased.create(context),
        ),
      ),
    );
  }
}
