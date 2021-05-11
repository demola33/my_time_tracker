import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_logo.dart';
import 'package:my_time_tracker/app/sign_in/components/social_sign_in_button.dart';
import 'package:my_time_tracker/app/sign_in/components/sign_in_button.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_sign_in_title.dart';
import 'package:my_time_tracker/blocs/sign_in/sign-in-manager.dart';
import 'package:my_time_tracker/common_widgets/or_divider.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'email_sign_in/email_sign_in_screen.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:my_time_tracker/common_widgets/firebase_auth_exception_alert_dialog.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;

  const SignInPage({Key key, @required this.isLoading, @required this.manager})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (BuildContext context) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, bloc, _) => SignInPage(
              manager: bloc,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Widget showProgressIndicator() {
    if (isLoading == true) {
      return Center(
        child: LinearProgressIndicator(),
      );
    } else {
      return Container();
    }
  }

  void _showSignInError(
      BuildContext context, FirebaseAuthException authException) {
    FirebaseAuthExceptionAlertDialog(
      title: 'Sign in Failed',
      exception: authException,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      body: Stack(
        children: [
          TimeTrackerLogo(),
          TimeTrackerSignInTitle(),
          _buildContent(context, isLoading.value),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: size.height * 0.05),
          showProgressIndicator(),
          SizedBox(height: size.height * 0.015),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: size.height * 0.01),
          SignInButton(
            text: 'Go Anonymously',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
          SizedBox(height: size.height * 0.01),
          OrDivider(),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialSignInButton(
                assetName: 'images/5.svg',
                press: () => isLoading ? null : _signInWithGoogle(context),
              ),
              SocialSignInButton(
                assetName: 'images/4.svg',
                press: () => isLoading ? null : _signInWithFacebook(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}
