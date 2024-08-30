import 'package:flutter/material.dart';
import 'package:grapp_mapping/auth/auth.wrapper.dart';

class UpdateSucScreen extends StatefulWidget {
  const UpdateSucScreen({super.key});

  @override
  State<UpdateSucScreen> createState() => _UpdateSucScreenState();
}

class _UpdateSucScreenState extends State<UpdateSucScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds and then navigate to the next screen
    Future.delayed(const Duration(seconds: 3), () {
      // Replace with your next screen's route
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0, // Optional: set a size for the icon
            ),
            SizedBox(height: 20), // Optional: add some spacing
            Text(
              'All changes have been saved successfully!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}