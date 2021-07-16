import 'package:flutter/foundation.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';
import 'package:my_time_tracker/services/auth_base.dart';

class EmailSignInModel with ErrorText, ChangeNotifier {
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
