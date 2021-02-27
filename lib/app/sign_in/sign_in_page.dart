import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_time_tracker/app/sign_in/components/social_sign_in_button.dart';
import 'package:my_time_tracker/app/sign_in/components/sign_in_button.dart';
import 'package:my_time_tracker/blocs/sign_in/loading_cubit.dart';
import 'package:my_time_tracker/common_widgets/or_divider.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'background.dart';
import 'email_sign_in/email_sign_in_screen.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';

class SignInPage extends StatelessWidget {
  final LoadingCubit bloc;

  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return BlocProvider(
      create: (_) => LoadingCubit(auth: auth),
      child: Consumer<LoadingCubit>(
        builder: (context, bloc, _) => SignInPage(
          bloc: bloc,
        ),
      ),
    );
  }

  Widget showSpinner(BuildContext context, LoadingState state) {
    if (state.isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
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
      await bloc.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Time Tracker',
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              color: Colors.deepOrangeAccent,
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.05),
          BlocBuilder<LoadingCubit, LoadingState>(
            builder: (context, state) {
              return showSpinner(context, state);
            },
          ),
          SizedBox(height: size.height * 0.10),
          SvgPicture.asset(
            'images/screen/center-welcome-icon.svg',
            height: size.height * 0.35,
          ),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return EmailSignInPage();
                  },
                ),
              );
            },
          ),
          SizedBox(height: size.height * 0.01),
          SignInButton(
            text: 'Go Anonymously',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: () => _signInAnonymously(context),
          ),
          SizedBox(height: size.height * 0.01),
          OrDivider(),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialSignInButton(
                assetName: 'images/5.svg',
                press: () => _signInWithGoogle(context),
              ),
              SocialSignInButton(
                assetName: 'images/4.svg',
                press: () => _signInWithFacebook(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}
