import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';
import 'package:my_time_tracker/services/auth_base.dart';

class EmailSignUpModel with EmailAndPasswordValidator, ChangeNotifier {
  String email;
  String firstName;
  String lastName;
  String password;
  String confirmPassword;
  bool submitted;
  bool isLoading;
  bool agree;
  bool isMatched;
  final AuthBase auth;

  EmailSignUpModel({
    this.email: '',
    this.firstName: '',
    this.lastName: '',
    this.password: '',
    this.confirmPassword: '',
    this.submitted: false,
    this.isLoading: false,
    this.agree: false,
    this.isMatched: false,
    @required this.auth,
  });

  Future<void> submit() async {
    updateWith(
      isLoading: true,
      submitted: true,
    );

    try {
      await auth.createUserWithEmailAndPassword(
          email, password, firstName, lastName);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(
        isLoading: false,
      );
    }
  }

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

  void updateWith({
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
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.submitted = submitted ?? this.submitted;
    this.isLoading = isLoading ?? this.isLoading;
    this.agree = agree ?? this.agree;
    this.isMatched = isMatched ?? this.isMatched;
    notifyListeners();
  }
}
