import 'package:my_time_tracker/app/screens/email_sign_in_screen.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_logo.dart';
import 'package:my_time_tracker/app/sign_in/components/social_sign_in_button.dart';
import 'package:my_time_tracker/app/sign_in/components/sign_in_button.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_sign_in_title.dart';
import 'package:my_time_tracker/blocs/sign_in/sign-in-manager.dart';
import 'package:my_time_tracker/common_widgets/or_divider.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/connectivity_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatefulWidget {
  final SignInManager manager;
  final bool isLoading;
  final bool isConnected;

  const SignInPage(
      {Key key,
      @required this.isLoading,
      @required this.manager,
      @required this.isConnected})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final connectivity = Provider.of<ConnectivityProvider>(context).online;

    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (BuildContext context) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, bloc, _) => SignInPage(
              manager: bloc,
              isLoading: isLoading.value,
              isConnected: connectivity,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await widget.manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await widget.manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        print(e.toString());
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await widget.manager.signInWithFacebook();
    } catch (e) {
      if (e.code != "CANCELLED_BY_USER") {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Scaffold portraitScaffold(BuildContext context, bool isLoading) {
    // final connect = Provider.of<ConnectivityProvider>(context).online;
    // print('connected: $connect');
    return Scaffold(
      backgroundColor: Color.fromRGBO(37, 165, 159, 0.6),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
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
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildLogo(context),
                  _buildSignInTitle(context),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _content(context, isLoading),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Scaffold landScapeScaffold(BuildContext context, bool isLoading) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(37, 165, 159, 0.6),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
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
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildLogo(context),
                _buildSignInTitle(context),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
    final isLoading = Provider.of<ValueNotifier<bool>>(context);
    print('initStatus: ${widget.isConnected}');
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portraitScaffold(context, isLoading.value);
    } else {
      return landScapeScaffold(context, isLoading.value);
    }
  }

  Widget _buildLogo(context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        child: TimeTrackerLogo(),
        width: 200,
        height: 200,
      ),
    );
  }

  Widget showProgressIndicator() {
    if (widget.isLoading == true) {
      return Center(
        child: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildSignInTitle(context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TimeTrackerSignInTitle(),
    );
  }

  List<Widget> _content(BuildContext context, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    return [
      showProgressIndicator(),
      SizedBox(height: 4.0),
      SignInButton(
        text: 'Sign in with Email',
        textColor: Colors.white,
        color: Colors.teal[600],
        onPressed: isLoading ? null : () => _signInWithEmail(context),
      ),
      SizedBox(height: size.height * 0.01),
      SignInButton(
        text: 'Go Anonymously',
        textColor: Color.fromRGBO(19, 66, 76, 1.0),
        color: Colors.lime[300],
        onPressed: isLoading ? null : () => _signInAnonymously(context),
      ),
      OrDivider(),
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
