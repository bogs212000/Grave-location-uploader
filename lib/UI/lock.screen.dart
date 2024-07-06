// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grapp_mapping/UI/home.screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Loading.dart';
import 'MyHomePage.dart';

TextEditingController password = new TextEditingController();
TextEditingController username = new TextEditingController();
String? pass;
String? uname;
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
      uname = snapshot.data()?['username'];
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
                              controller: username,
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
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400,
                                ),
                                labelText: "Username",
                                prefixIcon: const Icon(Icons.person_outline,
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
                          SizedBox(height: 20),
                          SizedBox(
                            child: TextField(
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
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400,
                                ),
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.person_outline,
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
                          auth == false
                              ? Text('Wrong Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.redAccent))
                              : Text('Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (password.text == pass) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()),
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
                                  backgroundColor: Color(0xFF265630),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: "Next".text.size(20).light.color(Colors.white).make(),
                            ),
                          ),
                          const SizedBox(height: 10),
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
