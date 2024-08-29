import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../cons/const.dart';
import '../signup/signup.screen.dart';

class PinInputPage extends StatefulWidget {
  @override
  _PinInputPageState createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optionally, you can set a default PIN here, but the user can edit it.
  }

  void _checkPinAndNavigate(String _pin) {
    if (_pin == pin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Enter PIN'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20),
            "Please enter the system PIN. If you do not know the PIN, please contact the developer."
                .text
                .make(),
            SizedBox(height: 20),
            Pinput(
              controller: _pinController,
              length: 6,
              // Length of the PIN
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onCompleted: (pin) {
                _checkPinAndNavigate(pin);
              },
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

