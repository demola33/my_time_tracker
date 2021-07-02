import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/services/auth_base.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  SignInManager({@required this.isLoading, @required this.auth});

  Future<CustomUser> _signIn(Future<CustomUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<CustomUser> signInAnonymously() async =>
      _signIn(auth.signInAnonymously);

  Future<CustomUser> signInWithGoogle() async => _signIn(auth.signInWithGoogle);

  Future<CustomUser> signInWithFacebook() async =>
      _signIn(auth.signInWithFacebook);
}
