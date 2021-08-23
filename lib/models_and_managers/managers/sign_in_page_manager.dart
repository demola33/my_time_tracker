import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/common_widgets/true_or_false_switch.dart';
import 'package:provider/provider.dart';

class SignInManager {
  final AuthBase auth;
  final BuildContext context;

  SignInManager({@required this.auth, @required this.context});

  Future<CustomUser> _signIn(
      BuildContext context, Future<CustomUser> Function() signInMethod) async {
    final isLoading = Provider.of<TrueOrFalseSwitch>(context, listen: false);
    try {
      isLoading.toggle();
      return await signInMethod().whenComplete(() => isLoading.toggle());
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomUser> signInAnonymously() async =>
      _signIn(context, auth.signInAnonymously);

  Future<CustomUser> signInWithGoogle() async =>
      _signIn(context, auth.signInWithGoogle);

  Future<CustomUser> signInWithFacebook() async =>
      _signIn(context, auth.signInWithFacebook);
}
