import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_time_tracker/services/auth_base.dart';

class EmailSignUpModel with ErrorText, ChangeNotifier {
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

  NameValidator get firstNameValidator {
    return NameValidator(errorText: firstNameError);
  }

  NameValidator get lastNameValidator {
    return NameValidator(errorText: lastNameError);
  }

  MultiValidator get passValidator {
    final String _pattern = r'(?=.*?[#?!@$%^&*-])';
    final passValidator = MultiValidator([
      RequiredValidator(errorText: requiredPasswordError),
      MinLengthValidator(8, errorText: minLengthError),
      PatternValidator(_pattern, errorText: passwordPatternError)
    ]);
    return passValidator;
  }

  MultiValidator get emailValidator {
    final validator = MultiValidator([
      RequiredValidator(errorText: requiredEmailError),
      EmailValidator(errorText: invalidEmailError),
    ]);
    return validator;
  }

  String passwordMatchValidator(String value) {
    return MatchValidator(errorText: passwordMatchError)
        .validateMatch(value, password);
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
