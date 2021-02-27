import 'package:meta/meta.dart';
import 'package:my_time_tracker/blocs/email_sign_in/email_sign_in_model.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'dart:async';

class EmailSignInBloc {
  final AuthBase auth;
  EmailSignInBloc({@required this.auth});

  final StreamController<EmailSignInModel> _modelSignInController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelSignInStream =>
      _modelSignInController.stream;
  EmailSignInModel _signInModel = EmailSignInModel();

  void dispose() {
    _modelSignInController.close();
  }

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    _signInModel = _signInModel.copyWith(
      email: email,
      password: password,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelSignInController.add(_signInModel);
  }

  Future<void> submit() async {
    updateWith(
      isLoading: true,
      submitted: true,
    );

    try {
      await Future.delayed(Duration(seconds: 5));
      await auth.signInWithEmailAndPassword(
          _signInModel.email, _signInModel.password);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(
        isLoading: false,
      );
    }
  }
}
