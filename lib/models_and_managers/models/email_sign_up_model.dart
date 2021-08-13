import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../services/auth_base.dart';
import '../../app/sign_in/components/validators.dart';

class EmailSignUpModel with ErrorText, ChangeNotifier {
  String email;
  String firstName;
  String lastName;
  String password;
  String confirmPassword;
  bool submitted;

  EmailSignUpModel({
    this.email: '',
    this.firstName: '',
    this.lastName: '',
    this.password: '',
    this.confirmPassword: '',
    this.submitted: false,
  });

  Future<void> submit(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.createUserWithEmailAndPassword(
          email, password, firstName, lastName);
    } catch (e) {
      rethrow;
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
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
