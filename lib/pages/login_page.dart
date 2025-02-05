import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swayamsevak/components/enrollment_page/password_input.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/components/login_page/login.dart';
import 'package:swayamsevak/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginService _loginService = LoginService();

  void _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar("Please fill out all fields", Colors.red);
      return;
    }

    final result = await _loginService.attemptLogin(username, password);

    if (result['success']) {
      final data = result['data'];
      _saveUserData(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _showSnackbar("Login successful", Colors.green);
      // Navigate to UserDashboard
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckLoginState()),
      );
    } else {
      _showSnackbar(result['error'], Colors.red);
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(data));
  }

  void _showSnackbar(String message, Color backgroundColor) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
