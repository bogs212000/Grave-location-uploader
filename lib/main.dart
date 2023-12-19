import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grapp_mapping/UI/MyHomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grapp_mapping/UI/lock.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uploader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/home': (context) => MyHomepage(),
          // Define the '/' route with LockScreen as the widget
          // You can define other routes here if needed
        },
        home: LockScreen());
  }
}
