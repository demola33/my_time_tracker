import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomUser {
  CustomUser({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<CustomUser> get authStateChanges;
  Future<void> signOut();
  CustomUser currentUser();
  Future<CustomUser> signInAnonymously();
  Future<CustomUser> signInWithGoogle();
  Future<CustomUser> signInWithFacebook();
  Future<CustomUser> signInWithEmailAndPassword(String email, String password);
  Future<CustomUser> createUserWithEmailAndPassword(
      String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  CustomUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return CustomUser(uid: user.uid);
  }

  @override
  Future<CustomUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')){
        throw PlatformException(
          code: 'no-network',
          message: 'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  @override
  Future<CustomUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try{
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } catch (e){
      if (e.message.contains('com.google.firebase.FirebaseException')){
        throw PlatformException(
          code: 'no-network',
          message: 'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  @override
  Future<CustomUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    final FacebookLoginResult result =
        await facebookLogin.logIn(['public_profile']);
    CustomUser customUser = CustomUser(uid: null);

    try{
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final token = result.accessToken.token;
          final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(token),
          );
          customUser = _userFromFirebase(userCredential.user);
          break;
        case FacebookLoginStatus.cancelledByUser:
          throw PlatformException(
            code: "CANCELLED_BY_USER",
            message: 'Cancelled by user',
          );
          break;
        case FacebookLoginStatus.error:
          throw PlatformException(
            code: "FACEBOOK_LOGIN_ERROR",
            message: result.errorMessage,
          );
          break;
      }
      return customUser;
    } catch (e){
      if (e.message.contains('com.google.firebase.FirebaseException')){
        throw PlatformException(
          code: 'no-network',
          message: 'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }

    }

  }

  @override
  Future<CustomUser> signInWithGoogle() async {
    try{
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );
          return _userFromFirebase(userCredential.user);
        } else {
          throw PlatformException(
            code: "ERROR_MISSING_GOOGLE_AUTH TOKEN",
            message: 'Missing Google Auth Token',
          );
        }
      } else {
        throw PlatformException(
          code: "ERROR_ABORTED_BY_USER",
          message: 'sign in aborted by user',
        );
      }
    } catch (e){
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Stream<CustomUser> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<CustomUser> signInAnonymously() async {
    try{
      final userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user);
    } catch (e){
      if (e.message.contains('com.google.firebase.FirebaseException')){
        throw PlatformException(
          code: 'no-network',
          message: 'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else if (e.code == 'admin-restricted-operation'){
        throw PlatformException(
          code: 'admin-restricted-operation',
          message: 'Anonymous sign-in has been disabled by the Administrator. Try other sign-in options.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }

  }

  @override
  Future<void> signOut() async {
    try{
      await GoogleSignIn().signOut();
      await FacebookLogin().logOut();
      return await _firebaseAuth.signOut();
    } catch (e){
      if (e.message.contains('com.google.firebase.FirebaseException')){
        throw PlatformException(
          code: 'no-network',
          message: 'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  @override
  CustomUser currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }
}
