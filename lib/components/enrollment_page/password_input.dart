import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const PasswordInputField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true; // Tracks whether the password is hidden or visible

  // Toggle the password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText, // Use the state to toggle visibility
      decoration: InputDecoration(
        labelText: widget.label,
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        fillColor: theme.inputDecorationTheme.fillColor,
        filled: true,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: _togglePasswordVisibility, // Toggle visibility on button press
        ),
      ),
    );
  }
}