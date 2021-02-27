import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/landing_page.dart';
import 'package:my_time_tracker/services/auth.dart';
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
    return Provider<AuthBase>(
      create: (BuildContext context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LandingPage(),
      ),
    );
  }
}
