import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black, // Default background color
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}
