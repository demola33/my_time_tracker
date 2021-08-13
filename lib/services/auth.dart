import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/app/home/account/otp_page.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
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
      isoCode: '',
    );
  }

  @override
  Future<CustomUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Verification Email Sent');
      }

      return _userFromFirebase(user);
    } catch (e) {
      print('ErrorCode: ${e.code}');
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
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
        isoCode: '',
      );
      await FirestoreDatabase(uid: userProfile.uid)
          .writeUserDataToFirestore(userProfile)
          .then((value) async {
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
        }
      }).catchError((onError) {});
      return userProfile;
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<CustomUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.logOut();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
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
          userProfile = _userFromFirebase(userCredential.user);
          if (userCredential.additionalUserInfo.isNewUser) {
            await FirestoreDatabase(uid: userProfile.uid)
                .writeUserDataToFirestore(userProfile);
          }
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
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<CustomUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
        CustomUser userProfile = _userFromFirebase(userCredential.user);
        if (userCredential.additionalUserInfo.isNewUser) {
          await FirestoreDatabase(uid: userProfile.uid)
              .writeUserDataToFirestore(userProfile);
        }
        return userProfile;
      } else {
        throw PlatformException(
          code: "ERROR_ABORTED_BY_USER",
          message: 'sign in aborted by user',
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Stream<CustomUser> get authStateChanges {
    Stream<CustomUser> customUserStream =
        _firebaseAuth.authStateChanges().map(_userFromFirebase);
    return customUserStream;
  }

  @override
  Future<CustomUser> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      User user = userCredential.user;
      String displayName = 'Anonymous';
      CustomUser userProfile = CustomUser(
        photoUrl: '',
        displayName: displayName,
        uid: user.uid,
        email: '',
        phone: '',
        isoCode: '',
      );
      await FirestoreDatabase(uid: userProfile.uid)
          .writeUserDataToFirestore(userProfile);
      return userProfile;
    } catch (e) {
      print(e.code);
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookLogin().logOut();
      return await _firebaseAuth.signOut();
    } catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  CustomUser currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> verifyUserPhoneNumber({
    @required BuildContext context,
    @required String number,
    @required String isoCode,
    int token,
  }) async {
    void _showVerifyPhoneNumberError(
        BuildContext context, PlatformException exception) {
      PlatformExceptionAlertDialog(
        title: 'Verification failed',
        exception: exception,
        onPressOk: () => Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context) => PhonePage(
              number: number,
              isoCode: isoCode,
              editNumberCallback: false,
            ),
          ),
        ),
      ).show(context);
    }

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      User user = _firebaseAuth.currentUser;
      try {
        await user
            .updatePhoneNumber(credential)
            .then((value) => FocusScope.of(context).requestFocus(FocusNode()))
            .whenComplete(() => FirestoreDatabase(uid: user.uid)
                .updateUserDataOnFirestore(
                    {'phone': '$number', 'countryCode': '$isoCode'}))
            .catchError((e) {
          throw PlatformException(
            code: e.code,
            message: e.message,
          );
        });
        //await Future.delayed(Duration(milliseconds: 100));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        _showVerifyPhoneNumberError(context, e);
      }
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      try {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      } catch (e) {
        print(e.code);
        print(e.message);
        _showVerifyPhoneNumberError(context, e);
      }
    };
    final PhoneCodeSent codeSent =
        (String verificationId, int resendToken) async {
      OTPPage.show(
          context: context,
          number: number,
          verificationId: verificationId,
          isoCode: isoCode,
          resendToken: resendToken);
    };
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      timeout: const Duration(seconds: 60),
      forceResendingToken: token,
      codeAutoRetrievalTimeout: (String verificationId) {
        print('VerificationId: $verificationId');
      },
    );
  }

  @override
  Future<void> phoneCredential({
    BuildContext context,
    String otp,
    String verificationId,
    String number,
    String isoCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      User user = _firebaseAuth.currentUser;
      await user
          .updatePhoneNumber(credential)
          .whenComplete(() => FocusScope.of(context).requestFocus(FocusNode()))
          .then((value) => FirestoreDatabase(uid: user.uid)
              .updateUserDataOnFirestore(
                  {'phone': '$number', 'countryCode': '$isoCode'}));
      //await Future.delayed(Duration(milliseconds: 100));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print(e.code);
      print(e.message);
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<void> updateUserImageURL(String photoURL) async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      await FirestoreDatabase(uid: user.uid).updateUserDataOnFirestore(
          {'imageURL': photoURL}).catchError((onError) {
        print('error occurred : ${onError.toString()}');
      });
    }
  }

  @override
  bool isUserVerified() {
    User user = _firebaseAuth.currentUser;
    bool verified = user.emailVerified;
    if (verified) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isUserAnonymous() {
    User user = _firebaseAuth.currentUser;
    bool anonymous = user.isAnonymous;
    if (anonymous) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> reloadUser() async {
    User user = _firebaseAuth.currentUser;
    await user.reload();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.code);
      print(e.message);
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
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
  Future<bool> reAuthenticateFacebookUser() async {
    FacebookAccessToken accessToken;
    FacebookLoginResult result;
    try {
      FacebookLogin facebookLogin = FacebookLogin();
      bool loggedIn = await facebookLogin.isLoggedIn;
      if (loggedIn) {
        FacebookAccessToken currentAccessToken =
            await facebookLogin.currentAccessToken;
        //currentAccessToken != null && currentAccessToken.isValid()
        if (2 > 3) {
          print('Delete my account');
          accessToken = currentAccessToken;
        } else {
          facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
          result = await facebookLogin.logIn(['public_profile']);

          if (result.status == FacebookLoginStatus.loggedIn) {
            accessToken = result.accessToken;
          } else if (result.status == FacebookLoginStatus.cancelledByUser) {
            throw PlatformException(
              code: "CANCELLED_BY_USER",
              message: 'Cancelled by user',
            );
          } else if (result.errorMessage == 'net::ERR_INTERNET_DISCONNECTED') {
            throw PlatformException(
              code: 'network_error',
            );
          } else {
            print(result.errorMessage);
            throw PlatformException(
              code: 'network_error',
              message: result.errorMessage,
            );
          }
        }

        final userCredential =
            await _firebaseAuth.currentUser.reauthenticateWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );
        return userCredential.user != null;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> reAuthenticateGoogleUser() async {
    String accessToken;
    String idToken;
    try {
      final user = GoogleSignIn();
      final GoogleSignInAccount googleUser = await user.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        accessToken = googleAuth.accessToken;
        idToken = googleAuth.idToken;
        if (accessToken != null && idToken != null) {
          final userCredential =
              await _firebaseAuth.currentUser.reauthenticateWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );
          if (userCredential != null) {
            await user.disconnect();
            print('user disconnected');
          }
          return userCredential != null;
        }
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    User user = _firebaseAuth.currentUser;
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> deleteUserAccount() async {
    await _firebaseAuth.currentUser.delete();
  }

  @override
  Future<void> removeUserPhone() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await _firebaseAuth.currentUser.unlink(PhoneAuthProvider.PROVIDER_ID);
        await FirestoreDatabase(uid: user.uid).updateUserDataOnFirestore(
          {'phone': ''},
        );
      } catch (e) {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }
}
