import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YearDropdown extends StatefulWidget {
  final String collegeId;
  final String departmentName;
  final ValueChanged<String?> onYearChanged; // Callback when a year is selected

  const YearDropdown({
    Key? key,
    required this.collegeId,
    required this.departmentName,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  List<String> years = [];
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    fetchYears(widget.collegeId, widget.departmentName);
  }

  Future<void> fetchYears(String collegeId, String departmentName) async {
    final String apiUrl =
        'http://213.210.37.81:1234/api/classes/$collegeId/$departmentName';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> classData = data['classes'];

        setState(() {
          // Assuming the API returns years as an array of strings
          years = List<String>.from(classData);
        });
      } else {
        throw Exception('Failed to load years');
      }
    } catch (error) {
      print('Error fetching years: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (years.isNotEmpty)
          DropdownButtonFormField<String>(
            value: selectedYear,
            items: years
                .map((year) => DropdownMenuItem<String>(
              value: year,
              child: Text(year),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedYear = value;
              });
              widget.onYearChanged(value); // Call the callback with selected year
            },
            decoration: const InputDecoration(
              labelText: 'Select Year',
              border: OutlineInputBorder(),
            ),
          )
      ],
    );
  }
}
