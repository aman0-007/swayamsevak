import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const EmailInputField({Key? key, required this.label, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        fillColor: theme.inputDecorationTheme.fillColor,
        filled: true,
        labelStyle: theme.inputDecorationTheme.labelStyle,
      ),
    );
  }
}
