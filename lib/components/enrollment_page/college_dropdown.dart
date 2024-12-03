import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollegeDropdown extends StatefulWidget {
  final ValueChanged<String?> onCollegeChanged; // Callback function for when a college is selected

  const CollegeDropdown({Key? key, required this.onCollegeChanged}) : super(key: key);

  @override
  State<CollegeDropdown> createState() => _CollegeDropdownState();
}

class _CollegeDropdownState extends State<CollegeDropdown> {
  List<Map<String, String>> collegeData = [];
  String? selectedCollegeName;
  String? selectedCollegeId;

  @override
  void initState() {
    super.initState();
    fetchCollegeData();
  }

  Future<void> fetchCollegeData() async {
    const String apiUrl = 'http://213.210.37.81:1234/api/college-names-and-ids';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          collegeData = data
              .map((item) => {
            'collegeName': item['collegeName'] as String,
            'clgDbId': item['clgDbId'] as String,
          })
              .toList();
        });
      } else {
        throw Exception('Failed to load college data');
      }
    } catch (error) {
      print('Error fetching college data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedCollegeName,
          items: collegeData
              .map((college) => DropdownMenuItem<String>(
            value: college['collegeName'],
            child: Text(college['collegeName']!),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCollegeName = value;
              selectedCollegeId = collegeData.firstWhere(
                      (college) => college['collegeName'] == value)['clgDbId'];
            });

            widget.onCollegeChanged(selectedCollegeId); // Pass the selected college ID
          },
          decoration: InputDecoration(
            labelText: 'College Name',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
