import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/landing_page.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatelessWidget {
   const EmailVerificationPage(this.email, {Key key}) : super(key: key);

  final String email;

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            FormSubmitButton(
              focusNode: null,
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(66, 150, 152, 0.8),
                Color.fromRGBO(255, 228, 115, 1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Email Verification',
                    style: CustomTextStyles.textStyleBold(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.teal[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'A verification link has been sent to ',
                      style: CustomTextStyles.textStyleBold(
                          fontSize: 12.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(
                          text: email,
                          style: CustomTextStyles.textStyleBold(
                            fontSize: 12.0,
                            color: Colors.teal[600],
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '. Please Click on the link in email to activate your account.',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormSubmitButton(
                    focusNode: FocusNode(),
                    text: 'Confirm My Email',
                    onPressed: () async {
                      var result = await OpenMailApp.openMailApp();

                      if (!result.didOpen && !result.canOpen) {
                        showNoMailAppsDialog(context);
                      } else if (!result.didOpen && result.canOpen) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return MailAppPickerDialog(
                              mailApps: result.options,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormSubmitButton(
                    focusNode: FocusNode(),
                    text: 'Proceed to Time Tracker',
                    onPressed: () async {
                      await auth.reloadUser();
                      final isUserVerified = auth.isUserVerified();
                      if (isUserVerified) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LandingPage(
                              databaseBuilder: (uid) =>
                                  FirestoreDatabase(uid: uid),
                            ),
                          ),
                        );
                      } else {
                        MyCustomSnackBar(
                          text: 'Please verify your email.',
                        ).show(context);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormSubmitButton(
                    focusNode: FocusNode(),
                    text: 'Sign out',
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
