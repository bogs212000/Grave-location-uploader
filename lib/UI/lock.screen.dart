// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grapp_mapping/UI/home.screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../cons/const.dart';
import 'Loading.dart';
import 'MyHomePage.dart';
import 'Pin/pin.input.dart';

TextEditingController password = new TextEditingController();
TextEditingController email = new TextEditingController();
String? uname;
bool loading = false;
bool? auth;
bool _isVisible = false;

class LockScreen extends StatefulWidget {
  static String id = "MyHomePage";

  LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    fetchpin(setState);
    super.initState();
  }

  Future<void> fetchpin(Function setState) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('App settings')
          .doc('App')
          .get();

      pin = snapshot.data()?['Pin'];
      setState(() {
        pin = pin;
      });
      print(pin);
    } catch (e) {
      // Handle errors
    }
  }

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }


  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/new/USER_SB3.png'),
                        // Replace with your image asset
                        fit:
                            BoxFit.fill, // This will cover the entire container
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          'Welcome Admin!'.text.size(25).make(),
                          SizedBox(height: 20),
                          SizedBox(
                            child: TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400,
                                ),
                                labelText: "Email",
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 219, 219, 219),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            child: TextField(
                              obscureText: _isVisible ? false : true,
                              controller: password,
                              keyboardType: TextInputType.visiblePassword,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 219, 219, 219),
                                  ),

                                ),
                                suffixIcon: IconButton(
                                  color: Colors.black,
                                  onPressed: () => updateStatus(),
                                  icon: Icon(_isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400,
                                ),
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 219, 219, 219),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  fname.value = fname.value.copyWith(
                                    text: value[0].toUpperCase() +
                                        value.substring(1),
                                    selection: TextSelection.collapsed(
                                        offset: value.length),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                              } catch (e) {
                                // Show error dialog if there's an exception
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(e.toString()),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF265630),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: "Sign In"
                                  .text
                                  .size(20)
                                  .light
                                  .color(Colors.white)
                                  .make(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(onTap: (){Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              PinInputPage(),
                            ),
                          );},child: "Sign up".text.make()),
                          Spacer(),
                          Image.asset(
                            'assets/new/GoForBigDevelopment.png',
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
