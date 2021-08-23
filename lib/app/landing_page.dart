import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/home_app.dart';
import 'package:my_time_tracker/app/screens/sign_in_page.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  final Database Function(String) databaseBuilder;

  LandingPage({Key key, @required this.databaseBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<CustomUser>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        CustomUser user = snapshot.data;
        if (user == null) {
          return SignInPage.create(context);
        }
        bool isVerified = auth.isUserVerified();
        bool isAnonymous = auth.isUserAnonymous();
        String providerID = auth.userProviderId();
        if (isVerified || isAnonymous || providerID == 'facebook.com') {
          return MultiProvider(
            providers: [
              Provider<CustomUser>.value(value: user),
              Provider<Database>(
                create: (_) => databaseBuilder(user.uid),
              )
            ],
            child: HomeApp(),
          );
        } else {
          return SignInPage.create(context);
        }
      },
    );
  }
}
