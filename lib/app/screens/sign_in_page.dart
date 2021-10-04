import '../../services/auth_base.dart';
import '../../common_widgets/or_divider.dart';
import '../../models_and_managers/managers/sign_in_page_manager.dart';
import '../../app/screens/email_sign_in_screen.dart';
import '../../common_widgets/true_or_false_switch.dart';
import '../../app/sign_in/components/sign_in_button.dart';
import '../../app/sign_in/components/time_tracker_logo.dart';
import '../../app/sign_in/components/social_sign_in_button.dart';
import '../../common_widgets/platform_exception_alert_dialog.dart';
import '../../app/sign_in/components/time_tracker_sign_in_title.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;

  const SignInPage({Key key, @required this.manager}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider(
      create: (_) => SignInManager(auth: auth, context: context),
      child: Consumer<SignInManager>(
        builder: (context, manager, _) => SignInPage(
          manager: manager,
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } catch (e) {
      if (e.code != "CANCELLED_BY_USER") {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => const EmailSignInPage(),
      ),
    );
  }

  Scaffold portraitScaffold(BuildContext context, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 165, 159, 0.6),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(66, 150, 152, 0.8),
                    Color.fromRGBO(255, 228, 115, 1),
                  ],
                ),
              ),
              width: size.width,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.085),
                  _buildLogo(context),
                  _buildSignInTitle(context),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: _content(context, isLoading),
              ),
            ),
          )
        ],
      ),
    );
  }

  Scaffold landScapeScaffold(BuildContext context, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 165, 159, 0.6),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(66, 150, 152, 0.8),
                    Color.fromRGBO(255, 228, 115, 1),
                  ],
                ),
              ),
              width: size.width,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.085),
                  _buildLogo(context),
                  _buildSignInTitle(context),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: _content(context, isLoading),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<TrueOrFalseSwitch>(builder: (context, _isLoading, child) {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          return portraitScaffold(context, _isLoading.value);
        } else {
          return landScapeScaffold(context, _isLoading.value);
        }
      }),
    );
  }

  Widget _buildLogo(context) {
    return const SizedBox(
      child: TimeTrackerLogo(
        topPadding: 30,
      ),
      width: 200,
      height: 200,
    );
  }

  Widget showProgressIndicator(bool isLoading) {
    if (isLoading) {
      return const Center(
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildSignInTitle(context) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: const TimeTrackerSignInTitle(),
      ),
    );
  }

  List<Widget> _content(BuildContext context, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    return [
      showProgressIndicator(isLoading),
      const SizedBox(height: 4.0),
      SignInButton(
        text: 'Sign in with Email',
        textColor: Colors.white,
        color: Colors.teal[600],
        onPressed: isLoading ? null : () => _signInWithEmail(context),
      ),
      SizedBox(height: size.height * 0.01),
      SignInButton(
        text: 'Go Anonymously',
        textColor: const Color.fromRGBO(19, 66, 76, 1.0),
        color: Colors.lime[300],
        onPressed: isLoading ? null : () => _signInAnonymously(context),
      ),
      const OrDivider(),
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
    ];
  }
}
