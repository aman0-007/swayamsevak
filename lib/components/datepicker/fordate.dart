import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final TextEditingController dateController;
  final String label;

  const DatePickerWidget({
    Key? key,
    required this.dateController,
    this.label = 'Select Date',
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate, // Today's date
      lastDate: DateTime(currentDate.year + 1, currentDate.month, currentDate.day), // One year ahead
    );

    if (selectedDate != null) {
      // Format the date as dd-MM-yyyy
      final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
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
