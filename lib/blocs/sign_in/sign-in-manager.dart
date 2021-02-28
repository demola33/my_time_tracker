import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/services/auth.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  SignInManager({@required this.isLoading, @required this.auth});

  Future<CustomUser> _signIn(Future<CustomUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 5));
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<CustomUser> signInAnonymously() async =>
      _signIn(auth.signInAnonymously);

  Future<CustomUser> signInWithGoogle() async => _signIn(auth.signInWithGoogle);

  Future<CustomUser> signInWithFacebook() async =>
      _signIn(auth.signInWithFacebook);
}
