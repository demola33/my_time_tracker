import 'package:my_time_tracker/app/sign_in/components/validators.dart';

class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel({
    this.email: '',
    this.password: '',
    this.isLoading: false,
    this.submitted: false,
  });
  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
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

  EmailSignInModel copyWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
