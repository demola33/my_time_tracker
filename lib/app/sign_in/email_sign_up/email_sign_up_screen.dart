import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/background.dart';
import 'email_sign_up_form_bloc_based.dart';
import 'package:my_time_tracker/common_widgets/custom_back_button.dart';

class EmailSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EmailSignUpFormBlocBased.create(context),
        ),
      ),
    );
  }
}
