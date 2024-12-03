import 'package:flutter/material.dart';

class DropdownInputField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T selectedValue;
  final ValueChanged<T?> onChanged;

  const DropdownInputField({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: theme.textTheme.bodyLarge,
        // ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: selectedValue,
          items: items
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: theme.inputDecorationTheme.filled,
            fillColor: theme.inputDecorationTheme.fillColor,
            border: theme.inputDecorationTheme.border,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
            labelStyle: theme.inputDecorationTheme.labelStyle,
            labelText: label
          ),
        ),
      ],
    );
  }
}
