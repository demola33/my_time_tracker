import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/background.dart';
import 'package:my_time_tracker/app/sign_in/email_sign_in/email_sign_in_form_bloc_based.dart';
import 'package:my_time_tracker/common_widgets/custom_back_button.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EmailSignInFormBlocBased.create(context),
        ),
      ),
    );
  }
}
