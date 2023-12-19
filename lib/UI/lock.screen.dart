import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';
import 'MyHomePage.dart';

TextEditingController password = new TextEditingController();
String? pass;
bool loading = false;
bool? auth;
class LockScreen extends StatefulWidget {
  static String id = "MyHomePage";

  LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    fetchpass(setState);
  }

  Future<void> fetchpass(Function setState) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('App settings')
          .doc('App')
          .get();

      pass = snapshot.data()?['password'];

      setState(() {
        pass = pass;
      });
      print(pass);
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 5, 44, 77)),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 0),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/cemetery.png',
                      scale: 5, color: Colors.white),
                  const Text('  Grave Mapping Uploader',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white)),
                  SizedBox(
                      child: TextField(
                    textAlign: TextAlign.center,
                    controller: password,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w400,
                      ),
                      // Add textAlign property to center the input text
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      alignLabelWithHint: true,
                    ),
                  )),
                  const SizedBox(height: 5),
                  auth == false ?  Text('Wrong Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.redAccent)) : Text('Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white)) ,
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (password.text == pass) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomepage()),
                            // Replace HomeScreen() with your actual home screen widget
                            (route) => false,
                          );
                          setState(() {
                            auth = true;
                          });
                        } else {
                          password.clear();
                              setState(() {
                                auth = false;
                              });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text("Enter"),
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          );
  }
}
