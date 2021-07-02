import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';
import 'package:my_time_tracker/services/auth_base.dart';

class EmailSignInModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInModel({
    this.email: '',
    this.password: '',
    this.isLoading: false,
    this.submitted: false,
    @required this.auth,
  });
  String email;
  String password;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  Future<void> submit() async {
    updateWith(
      isLoading: true,
      submitted: true,
    );

    try {
      await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(
        isLoading: false,
      );
    }
  }

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
