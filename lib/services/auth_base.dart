import 'package:flutter/material.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';

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
  Future<bool> validateCurrentPassword(String newPassword);
  Future<void> updatePassword(String newPassword);

  Future<CustomUser> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName);
  Future<void> updateUserImageURL(String photoURL);
  Future<void> verifyUserPhoneNumber(BuildContext context, String number);
  Future<void> phoneCredential(
      {BuildContext context, String otp, String verificationId, String number});
}
