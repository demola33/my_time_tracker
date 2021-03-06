import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home_page.dart';
import 'package:my_time_tracker/app/sign_in/sign_in_page.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<CustomUser>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          CustomUser user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return HomePage();
        } else {
          return Scaffold(
            body: Container(
              height: size.height,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
