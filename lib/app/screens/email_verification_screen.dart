import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key key}) : super(key: key);

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(66, 150, 152, 0.8),
                Color.fromRGBO(255, 228, 115, 1),
              ],
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Email Verification',
                    style: CustomTextStyles.textStyleBold(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.teal[700]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'A verification link has been sent to the email provided. Please Click on the link in email to activate your account.',
                    style: CustomTextStyles.textStyleBold(
                      fontSize: 12.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w800,
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
                      Navigator.popUntil(context, (route) => route.isFirst);
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
