import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/services/auth.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  final AuthBase auth;
  LoadingCubit({@required this.auth}) : super(LoadingState(isLoading: false));

  void _beginLoadingState(bool value) => emit(
        LoadingState(isLoading: value),
      );
  Future<CustomUser> _signIn(Future<CustomUser> Function() signInMethod) async {
    try {
      _beginLoadingState(true);
      await Future.delayed(Duration(seconds: 5));
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      _beginLoadingState(false);
    }
  }

  Future<CustomUser> signInAnonymously() async =>
      _signIn(auth.signInAnonymously);

  Future<CustomUser> signInWithGoogle() async => _signIn(auth.signInWithGoogle);

  Future<CustomUser> signInWithFacebook() async =>
      _signIn(auth.signInWithFacebook);
}
