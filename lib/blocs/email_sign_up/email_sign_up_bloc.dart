import 'dart:async';

import 'package:my_time_tracker/blocs/email_sign_up/email_sign_up_model.dart';
import 'package:my_time_tracker/services/auth.dart';

class EmailSignUpBloc {
  final AuthBase auth;
  StreamController<EmailSignUpModel> _modelSignUpController =
      StreamController<EmailSignUpModel>();

  EmailSignUpBloc({this.auth});

  Stream<EmailSignUpModel> get modelSignUpStream =>
      _modelSignUpController.stream;
  EmailSignUpModel _signUpModel = EmailSignUpModel();

  void dispose() {
    _modelSignUpController.close();
  }

  bool isMatched() {
    if (_signUpModel.password == _signUpModel.confirmPassword) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> submit() async {
    updateWith(
      isLoading: true,
      submitted: true,
    );

    try {
      print('isMatched: ${isMatched()}');
      if (isMatched()) {
        await Future.delayed(Duration(seconds: 5));
        await auth.createUserWithEmailAndPassword(
            _signUpModel.email, _signUpModel.password);
      } else {
        print("Password do not Match");
      }
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
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
    bool submitted,
    bool isLoading,
    bool agree,
    bool isMatched,
  }) {
    _signUpModel = _signUpModel.copyWith(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        confirmPassword: confirmPassword,
        submitted: submitted,
        isLoading: isLoading,
        agree: agree,
        isMatched: isMatched);
    _modelSignUpController.add(_signUpModel);
  }
}
