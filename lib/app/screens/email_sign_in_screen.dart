import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_in/email_sign_in_form_change_notifier_based.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 165, 159, 0.6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(66, 150, 152, 0.8),
                  Color.fromRGBO(255, 228, 115, 1),
                ],
              ),
            ),
            child: EmailSignInFormChangeNotifierBased.create(context),
          ),
        ),
      ),
    );
  }
}
