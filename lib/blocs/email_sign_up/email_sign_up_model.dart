import 'package:my_time_tracker/app/sign_in/components/validators.dart';

class EmailSignUpModel with EmailAndPasswordValidator {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final bool submitted;
  final bool isLoading;
  final bool agree;
  final bool isMatched;

  EmailSignUpModel(
      {this.email: '',
      this.firstName: '',
      this.lastName: '',
      this.password: '',
      this.confirmPassword: '',
      this.submitted: false,
      this.isLoading: false,
      this.agree: false,
      this.isMatched: false});

  bool get isPasswordMatch {
    if (password != confirmPassword) {
      return false;
    } else {
      return true;
    }
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        passwordValidator.isValid(confirmPassword) &&
        firstNameValidator.isValid(firstName) &&
        lastNameValidator.isValid(lastName) &&
        !isLoading &&
        isPasswordMatch;
  }

  String get firstNameErrorText {
    bool showErrorText = submitted && !firstNameValidator.isValid(firstName);
    return showErrorText ? invalidFirstNameErrorText : null;
  }

  String get lastNameErrorText {
    bool showErrorText = submitted && !lastNameValidator.isValid(lastName);
    return showErrorText ? invalidLastNameErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get confirmPasswordErrorText {
    bool showErrorText = submitted &&
            !confirmPasswordValidator.isValid(confirmPassword) ||
        (confirmPasswordValidator.isValid(confirmPassword) && !isPasswordMatch);
    return showErrorText ? invalidConfirmPasswordErrorText : null;
  }

  EmailSignUpModel copyWith({
    String email,
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
    bool submitted,
    bool isLoading,
    bool agree,
    bool isMatched,
  }) {
    return EmailSignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      submitted: submitted ?? this.submitted,
      isLoading: isLoading ?? this.isLoading,
      agree: agree ?? this.agree,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
