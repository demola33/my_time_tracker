import 'package:cloud_firestore/cloud_firestore.dart';
import 'platform_alert_dialog.dart';
import 'package:meta/meta.dart';

class FirebaseExceptionAlertDialog extends PlatformAlertDialog {
  FirebaseExceptionAlertDialog({
    @required String title,
    @required FirebaseException exception,
  }) : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );

  static String _message(FirebaseException exception) {
    if (exception.code == "permission-denied") {
      if (exception.message ==
          "The caller does not have permission to execute the specified operation.") {
        return "You  do not have permission to execute this operation.";
      }
    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'invalid-email': "Please use a valid email address",

    ///  - Thrown if the email address is not valid.
    /// - **user-disabled**:
    ///  - Thrown if the user corresponding to the given email has been disabled.
    /// - **user-not-found**:
    ///  - Thrown if there is no user corresponding to the given email.
    'wrong-password': "The Password is invalid",

    ///  - Thrown if the password is invalid for the given email, or the account
    ///    corresponding to the email does not have a password set.

    'email-already-in-use':
        "This Email address is already in use by another user.",

    ///  - Thrown if there already exists an account with the given email address.
    /// - **invalid-email**:
    ///  - Thrown if the email address is not valid.
    /// - **operation-not-allowed**:
    ///  - Thrown if email/password accounts are not enabled. Enable
    ///    email/password accounts in the Firebase Console, under the Auth tab.
    /// - **weak-password**:
    ///  - Thrown if the password is not strong enough.
    ///
    /// - **operation-not-allowed**:
    ///  - Thrown if anonymous accounts are not enabled. Enable anonymous accounts
    /// in the Firebase Console, under the Auth tab.
  };
}
