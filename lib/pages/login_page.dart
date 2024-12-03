import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/components/enrollment_page/password_input.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginType = 'student'; // 'student' or 'po'

  void _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar("Please fill out all fields", Colors.red);
      return;
    }

    final loginData = {
      'identifier': username,
      'password': password,
    };

    final apiUrl = loginType == 'student'
        ? 'http://213.210.37.81:1234/api/student-login'
        : 'http://213.210.37.81:1234/api/teacher-po-login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'] ?? "Login successful";

        if (message == "Login successful") {
          // Store user data if login is successful
          // You can store the user data in SharedPreferences or any local storage
          _showSnackbar(message, Colors.green);
        } else {
          _showSnackbar(message, Colors.red);
        }
      } else {
        final responseBody = jsonDecode(response.body);
        _showSnackbar(responseBody['message'] ?? "Login failed", Colors.red);
      }
    } catch (e) {
      _showSnackbar("An error occurred: $e", Colors.red);
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextInputField(label: "Username", controller: usernameController),
              const SizedBox(height: 16),
              PasswordInputField(label: "Password", controller: passwordController),
              const SizedBox(height: 24),
              ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                onPressed: _handleLogin,
                child: const Text("Login"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login as "),
                  GestureDetector(
                    onTap: () => setState(() => loginType = 'student'),
                    child: Text("Student", style: TextStyle(color: loginType == 'student' ? Colors.blue : Colors.black)),
                  ),
                  const Text(" / "),
                  GestureDetector(
                    onTap: () => setState(() => loginType = 'po'),
                    child: Text("PO/Teacher", style: TextStyle(color: loginType == 'po' ? Colors.blue : Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
