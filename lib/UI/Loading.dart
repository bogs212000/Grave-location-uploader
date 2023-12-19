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
                  color: Colors.blue.shade900,
                ),
                const SizedBox(width: 10),
                const Text("Loading...",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blueGrey,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),),),
      ),);
  }
}
