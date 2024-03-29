import 'package:flutter/material.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';

abstract class AuthBase {
  Stream<CustomUser> get authStateChanges;
  //Stream<CustomUser> get userChanges;

  Future<void> signOut();

  CustomUser currentUser();

  String userProviderId();

  Future<CustomUser> signInAnonymously();

  Future<CustomUser> signInWithGoogle();

  Future<CustomUser> signInWithFacebook();

  Future<CustomUser> signInWithEmailAndPassword(String email, String password);

  Future<void> removeUserPhone();

  Future<void> deleteUserAccount();

  Future<bool> validateCurrentPassword(String newPassword);
  Future<bool> reAuthenticateFacebookUser();
  Future<bool> reAuthenticateGoogleUser();

  Future<void> updatePassword(String newPassword);

  Future<void> sendPasswordResetEmail(String email);

  bool isUserVerified();
  bool isUserAnonymous();

  Future<void> reloadUser();

  Future<CustomUser> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName);

  Future<void> updateUserImageURL(String photoURL);

  Future<void> verifyUserPhoneNumber({
    @required BuildContext context,
    @required String number,
    @required String isoCode,
    int token,
  });

  Future<void> phoneCredential({
    BuildContext context,
    String otp,
    String verificationId,
    String number,
    String isoCode,
  });
}
