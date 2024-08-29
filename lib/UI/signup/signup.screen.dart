import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await _store.collection('User').doc(
          _emailController.text.toString().trim()).set(
          {'password': _passwordController.text.toString().trim()});

      // Navigate to another page if needed
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Sign Up'),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              child: TextField(
                controller: _emailController,
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
            SizedBox(height: 16),
            SizedBox(
              child: FancyPasswordField(
                validationRules: {DigitValidationRule(),
                  UppercaseValidationRule(),
                  LowercaseValidationRule(),
                  SpecialCharacterValidationRule(),},
                validationRuleBuilder: (rules, value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rules.map((rule) {
                      final ruleStatus = rule.validate(value);
                      return Row(
                        children: [
                          Icon(
                            ruleStatus ? Icons.check_circle : Icons.circle,
                            color: ruleStatus ? Colors.green : Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            rule.name,
                            style: TextStyle(
                              color: ruleStatus ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
                controller: _passwordController,
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
                  labelText: "Create Password",
                  prefixIcon: const Icon(Icons.lock_outline,
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
            // SizedBox(
            //   child: FancyPasswordField(
            //     controller: _confirmPasswordController,
            //     keyboardType: TextInputType.emailAddress,
            //     style: const TextStyle(
            //       fontSize: 14.0,
            //       color: Colors.black,
            //       letterSpacing: .5,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     decoration: InputDecoration(
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(20),
            //         borderSide: const BorderSide(
            //           color: Color.fromARGB(255, 219, 219, 219),
            //         ),
            //       ),
            //       filled: true,
            //       fillColor: Colors.white,
            //       labelStyle: const TextStyle(
            //         fontSize: 13.0,
            //         color: Colors.black,
            //         letterSpacing: .5,
            //         fontWeight: FontWeight.w400,
            //       ),
            //       labelText: "Email",
            //       prefixIcon: const Icon(Icons.person_outline,
            //           color: Colors.black),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(
            //           color: Color.fromARGB(255, 219, 219, 219),
            //         ),
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  try {

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
                child: "Sign up"
                    .text
                    .size(20)
                    .light
                    .color(Colors.white)
                    .make(),
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/new/GoForBigDevelopment.png',
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
