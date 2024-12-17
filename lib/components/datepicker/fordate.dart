import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final TextEditingController dateController;
  final String label;

  const DatePickerWidget({
    Key? key,
    required this.dateController,
    this.label = 'Select Date',
  }) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  // ISO Format Function: Returns 2023-12-01T09:00:00Z
  String _formatToISO(DateTime date) {
    return date.toUtc().toIso8601String().split('.')[0] + 'Z';
  }

  Future<void> _pickDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate, // Start today
      lastDate: DateTime(currentDate.year + 1, currentDate.month, currentDate.day), // End 1 year ahead
    );

    if (selectedDate != null) {
      // Save date as ISO format and display as dd-MM-yyyy
      final isoDate = _formatToISO(selectedDate);
      final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

      widget.dateController.text = formattedDate;

      // Optional: Print or use ISO-formatted date
      print("Selected Date in ISO format: $isoDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _pickDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }
}
