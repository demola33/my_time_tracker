import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/app/home/account/otp_page.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/database.dart';

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  CustomUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return CustomUser(
      uid: user.uid,
      photoUrl: user.photoURL ?? '',
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
    );
  }

  _showAlertDialog(
      {BuildContext context, String message, VoidCallback onPress}) {
    Widget okButton = TextButton(
      onPressed: onPress,
      child: Text(
        'OK',
        style: CustomTextStyles.textStyleBold(),
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        'Operation Failed',
        style: CustomTextStyles.textStyleBold(),
      ),
      content: Text(
        message,
        style: CustomTextStyles.textStyleNormal(),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Future<CustomUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      if (e.message
          .toString()
          .contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else if (e.message.toString().contains('String is empty or null')) {
        throw PlatformException(
          code: 'empty-credential',
          message: 'Please input a valid email and password.',
        );
      } else {
        print(e.code);
        print(e.message);
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  @override
  String userProviderId() {
    User user = _firebaseAuth.currentUser;
    if (user.providerData.isEmpty) {
      return 'Anonymous';
    } else {
      return user.providerData[0].providerId;
    }
  }

  @override
  Future<CustomUser> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;

      String displayName = '$lastName' + ' ' + '$firstName';

      CustomUser userProfile = CustomUser(
        displayName: displayName ?? '',
        uid: user.uid,
        email: email ?? '',
        phone: '',
        photoUrl: '',
      );
      await FirestoreDatabase(uid: userProfile.uid)
          .writeUserDataToFirestore(userProfile);
      return userProfile;
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
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
    CustomUser userProfile;

    try {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final token = result.accessToken.token;
          final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(token),
          );
          //print('Facebook User Phone number: ${userCredential.user.phoneNumber}');
          userProfile = _userFromFirebase(userCredential.user);
          await FirestoreDatabase(uid: userProfile.uid)
              .writeUserDataToFirestore(userProfile);
          //customUser = _userFromFirebase(userCredential.user);
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
      return userProfile;
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
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
    try {
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
          CustomUser userProfile = _userFromFirebase(userCredential.user);
          print('Provider Data: ${userCredential.user.providerData}');
          print(
              'Provider ID: ${userCredential.user.providerData[0].providerId}');
          await FirestoreDatabase(uid: userProfile.uid)
              .writeUserDataToFirestore(userProfile);
          return userProfile;
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
    } catch (e) {
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

  // @override
  // Stream<CustomUser> get userChanges {
  //   return _firebaseAuth.userChanges().map(_userFromFirebase);
  // }

  @override
  Future<CustomUser> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      User user = userCredential.user;
      String displayName = 'Anonymous';
      CustomUser userProfile = CustomUser(
        photoUrl: '',
        displayName: displayName ?? '',
        uid: user.uid,
        email: '',
        phone: '',
      );
      print('Provider Data: ${user.providerData.toString()}');

      await FirestoreDatabase(uid: userProfile.uid)
          .writeUserDataToFirestore(userProfile);

      return userProfile;
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else if (e.code == 'admin-restricted-operation') {
        throw PlatformException(
          code: 'admin-restricted-operation',
          message:
              'Anonymous sign-in has been disabled by the Administrator. Try other sign-in options.',
        );
      } else {
        print(e.message);
        print(e.code);
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookLogin().logOut();
      return await _firebaseAuth.signOut();
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
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

  @override
  Future<void> verifyUserPhoneNumber(
      BuildContext context, String number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await _firebaseAuth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        String message = 'The provided phone number is not valid.';
        _showAlertDialog(
          context: context,
          message: message,
          onPress: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => PhonePage(number: number),
            ),
          ),
        );
      }
      if (e.code == 'network-request-failed') {
        String message =
            'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.';
        _showAlertDialog(
          context: context,
          message: message,
          onPress: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => PhonePage(number: number),
            ),
          ),
        );
      } else {
        String message = 'An Error has occured';
        _showAlertDialog(
          context: context,
          message: message,
          onPress: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => PhonePage(number: number),
            ),
          ),
        );
      }
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int resendToken) async {
      OTPPage.show(context, number, verificationId);
    };

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        print('VerificationId: $verificationId');
      },
    );
    print('verification done');
  }

  @override
  Future<void> updateUserImageURL(String photoURL) async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      await FirestoreDatabase(uid: user.uid).updateUserDataOnFirestore(
          {'imageURL': photoURL}).catchError((onError) {
        print('error occured : ${onError.toString()}');
      });
      //await user.updatePhotoURL(photoURL).onError((error, stackTrace) =>
      // print('Error Uploading Image : ${error.toString()}'));
    }
  }

  @override
  Future<bool> validateCurrentPassword(String currentPassword) async {
    User user = _firebaseAuth.currentUser;

    final authCredential = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);
    try {
      final authResult =
          await user.reauthenticateWithCredential(authCredential);
      return authResult.user != null;
    } catch (e) {
      print(e.code);
      print(e.message);
      return false;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    User user = _firebaseAuth.currentUser;
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> removeUserPhone() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      _firebaseAuth.currentUser
          .unlink(PhoneAuthProvider.PROVIDER_ID)
          .whenComplete(
            () async => await FirestoreDatabase(uid: user.uid)
                .updateUserDataOnFirestore(
              {'phone': ''},
            ),
          );
    }
  }

  @override
  Future<void> phoneCredential(
      {BuildContext context,
      String otp,
      String verificationId,
      String number}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      User user = _firebaseAuth.currentUser;
      await user.updatePhoneNumber(credential);
      await FirestoreDatabase(uid: user.uid)
          .updateUserDataOnFirestore({'phone': '$number'});
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        if (e.code.toString() == 'credential-already-in-use') {
          String message =
              'This Phone number is already associated with a different user account';
          _showAlertDialog(
              context: context,
              message: message,
              onPress: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst));
        } else if (e.code.toString() == 'invalid-verification-code') {
          String message = 'Please use a valid verification code.';
          _showAlertDialog(
            context: context,
            message: message,
            onPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => OTPPage(
                  number: number,
                  verificationId: verificationId,
                ),
              ),
            ),
          );
        } else if (e.message.contains('too-many-requests')) {
          String message =
              'We have blocked all requests from this device due to unusual activity. Try again later.';
          _showAlertDialog(
              context: context,
              message: message,
              onPress: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst));
        } else {
          print('errorCode: ${e.code}');
          print('errorMessage: ${e.message}');
          String message =
              'An unknown error has occurred, kindly send a mail to our team for help.';
          _showAlertDialog(
              context: context,
              message: message,
              onPress: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst));
        }
      }
    }
  }
}
