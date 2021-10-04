import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class EmailSignInViewModel with ErrorText, ChangeNotifier {
  EmailSignInViewModel({
    this.email = '',
    this.password = '',
  });
  String email;
  String password;

  MultiValidator get emailValidator {
    final validator = MultiValidator([
      RequiredValidator(errorText: requiredEmailError),
      EmailValidator(errorText: invalidEmailError),
    ]);
    return validator;
  }

  RequiredValidator get requiredValidator {
    return RequiredValidator(errorText: requiredPasswordError);
  }

  void _showResetPasswordError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Reset Password failed',
      exception: exception,
    ).show(context);
  }

  Future<void> submit(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgetPassword({
    @required BuildContext context,
    @required String email,
  }) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    bool error = false;
    try {
      await auth.sendPasswordResetEmail(email).catchError((e) {
        error = true;
        _showResetPasswordError(context, e);
      });
      if (error == false) {
        PlatformAlertDialog(
          title: 'Instructions sent',
          content:
              'We sent instructions to change your password to $email, Please check both your inbox and spam folder',
          defaultActionText: 'Ok',
        ).show(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({
    String email,
    String password,
    bool error,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    notifyListeners();
  }
}
