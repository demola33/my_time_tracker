import 'package:flutter/material.dart';
import '../sign_in/email_sign_up/email_sign_up_form_change_notifier_based.dart';

class EmailSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(37, 165, 159, 0.6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.05,
            decoration: BoxDecoration(
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
            //padding: const EdgeInsets.all(8.0),
            child: EmailSignUpFormChangeNotifierBased.create(context),
          ),
        ),
      ),
    );
  }
}
