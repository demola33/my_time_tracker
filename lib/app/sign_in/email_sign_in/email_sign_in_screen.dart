import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_in/email_sign_in_form_change_notifier_based.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EmailSignInFormChangeNotifierBased.create(context),
        ),
      ),
    );
  }
}
