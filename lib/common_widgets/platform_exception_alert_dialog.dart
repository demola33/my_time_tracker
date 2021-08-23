import 'dart:ui';

import 'package:flutter/services.dart';

import 'platform_alert_dialog.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
    VoidCallback onPressOk,
    VoidCallback onPressCancel,
  }) : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
          onPressOk: onPressOk,
          onPressCancel: onPressCancel,
        );

  static String _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'invalid-email': "Please use a valid email address",
    'invalid-verification-code': 'Please use a valid verification code.',
    'network-request-failed':
        'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
    'no-such-provider': 'This phone number is not linked with your account.',
    "ERROR_MISSING_GOOGLE_AUTH TOKEN": 'Missing Google Auth Token',
    "ERROR_ABORTED_BY_USER": 'sign in aborted by user',
    'failed_to_recover_auth': 'An error has occurred.',
    'user_recoverable_auth': 'An error has occurred.',
    'sign_in_canceled': 'Canceled by user.',
    'sign_in_required': 'Please sign in using your google credentials.',
    'network_error':
        'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
    'admin-restricted-operation':
        'Anonymous sign-in has been disabled by the Administrator. Try other sign-in options.',

    ///  - Thrown if the email address is not valid.
    /// - **user-disabled**:
    ///  - Thrown if the user corresponding to the given email has been disabled.
    /// - **user-not-found**:
    ///  - Thrown if there is no user corresponding to the given email.
    'wrong-password': "The Password is invalid",
    'auth/invalid-email': "Please use a valid email address",
    'user-not-found': 'There is no user record corresponding to this email.',
    'credential-already-in-use':
        'This Phone number is already associated with a different user account',

    ///  - Thrown if the password is invalid for the given email, or the account
    ///    corresponding to the email does not have a password set.

    'email-already-in-use':
        "This Email address is already in use by another user.",
    //'network_error':
    //  'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',

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
