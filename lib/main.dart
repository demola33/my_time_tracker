import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/landing_page.dart';
import 'package:my_time_tracker/app/screens/splash_screen.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:my_time_tracker/services/connectivity_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        Provider<AuthBase>(create: (BuildContext context) => Auth()),
        Provider<Format>(create: (BuildContext context) => Format()),
      ],
      child: FutureBuilder(
        // Replace the 3 second delay with your initialization code:
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            Future.delayed(Duration(seconds: 3));
            return MaterialApp(
                debugShowCheckedModeBanner: false, home: SplashScreen());
          } else {
            // Loading is done, return the app:
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Time Tracker',
              theme: ThemeData(
                primarySwatch: Colors.teal,
              ),
              home: LandingPage(),
            );
          }
        },
      ),
    );
  }
}
