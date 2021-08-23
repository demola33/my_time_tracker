import 'dart:async';

import 'package:country_codes/country_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/landing_page.dart';
import 'package:my_time_tracker/app/screens/splash_screen.dart';
import 'package:my_time_tracker/common_widgets/true_or_false_switch.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/connectivity_provider.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CountryCodes.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 8),
      () => navigatorKey.currentState.pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => LandingPage(
            databaseBuilder: (uid) => FirestoreDatabase(uid: uid),
          ),
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectivityProvider>(
            create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider<TrueOrFalseSwitch>(
            create: (context) => TrueOrFalseSwitch()),
        Provider<AuthBase>(create: (BuildContext context) => Auth()),
        Provider<Format>(create: (BuildContext context) => Format()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
