import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grapp_mapping/UI/MyHomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grapp_mapping/UI/home.screen.dart';
import 'package:grapp_mapping/UI/lock.screen.dart';

import 'UI/add.screen.dart';
import 'UI/success/update.success.dart';
import 'auth/auth.wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
          '/home': (context) => SearchScreen(),
          '/updateSuccess': (context) => UpdateSucScreen(),
          '/add': (context) => AddScreen(),
          // Define the '/' route with LockScreen as the widget
          // You can define other routes here if needed
        },
      home: AuthWrapper(),);
  }
}
