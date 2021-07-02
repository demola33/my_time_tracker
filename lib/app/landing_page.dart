import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/home_app.dart';
import 'package:my_time_tracker/app/screens/sign_in_page.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  final Database Function(String) databaseBuilder;

  const LandingPage({Key key, @required this.databaseBuilder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('I GOT REBUILT HERE......');
    final auth = Provider.of<AuthBase>(context, listen: false);
    //Size size = MediaQuery.of(context).size;
    return StreamBuilder<CustomUser>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        //if (snapshot.connectionState == ConnectionState.active) {
        CustomUser user = snapshot.data;
        if (user == null) {
          return SignInPage.create(context);
        }
        print('user:${user.uid}');
        return Provider<CustomUser>.value(
          value: user,
          child: Provider<Database>(
            create: (_) => databaseBuilder(user.uid),
            child: HomeApp(),
          ),
        );
        //}
        //  else {
        //   return Scaffold(
        //     body: Container(
        //       color: Colors.white,
        //       //color: Color.fromRGBO(237, 235, 173, 1),
        //       height: size.height,
        //       width: double.infinity,
        //       child: Center(
        //         //child: SplashScreen(),
        //         child: CircularProgressIndicator(),
        //       ),
        //     ),
        //   );
        // }
      },
    );
  }
}
