// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.green[900],
                ),
                const SizedBox(width: 10),
                Text("Loading...",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.green[900],
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),),),
      ),);
  }
}
