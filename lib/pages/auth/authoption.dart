import 'package:flutter/material.dart';
import '../enrollment_page.dart';
import '../login_page.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose an option',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 200, // Set a fixed width for both buttons
              height: 50, // Set a fixed height for both buttons
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Sign Up page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnrollmentPage()),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200, // Set the same width for both buttons
              height: 50, // Set the same height for both buttons
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Log In page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}