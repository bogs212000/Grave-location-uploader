// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grapp_mapping/UI/home.screen.dart';
import 'package:grapp_mapping/UI/lock.screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = FirebaseAuth.instance.currentUser?.email;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc('$email')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userData) {
        if (!userData.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (userData.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (userData.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Something went wrong!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 231, 25, 25),
                ),
              ),
            ],
          );
        } else if (userData.hasData) {
          return Builder(
            builder: (
              context,
            ) {
              if (userData.data!['role'] == "admin") {
                return SearchScreen();
              } else {
                return LockScreen();
              }
            },
          );
        } else {
          return LockScreen();
        }
      },
    );
  }
}
