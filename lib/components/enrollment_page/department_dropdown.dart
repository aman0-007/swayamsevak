import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepartmentDropdown extends StatefulWidget {
  final String collegeId; // The college ID to fetch departments for
  final ValueChanged<String?> onDepartmentChanged; // Callback function for when a department is selected

  const DepartmentDropdown({
    Key? key,
    required this.collegeId,
    required this.onDepartmentChanged,
  }) : super(key: key);

  @override
  _DepartmentDropdownState createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {
  List<String> departmentNames = [];
  String? selectedDepartment;

  @override
  void didUpdateWidget(covariant DepartmentDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collegeId != widget.collegeId) {
      departmentNames.clear();
      selectedDepartment = null;
      fetchDepartments(widget.collegeId);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.collegeId.isNotEmpty) {
      fetchDepartments(widget.collegeId);
    }
  }

  Future<void> fetchDepartments(String collegeId) async {
    final String apiUrl = 'http://213.210.37.81:1234/api/departments/$collegeId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body); // Decode as Map
        final List<dynamic> departments = data['departments']; // Extract the departments list

        setState(() {
          // Extract the department_name and add it to the list
          departmentNames = departments
              .map((item) => item['department_name'] as String) // Access the department_name key
              .toList();
        });
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (error) {
      print('Error fetching departments: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedDepartment,
          items: departmentNames
              .map((department) => DropdownMenuItem<String>(
            value: department,
            child: Text(department),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedDepartment = value;
            });
            widget.onDepartmentChanged(value); // Call the callback with selected department
          },
          decoration: InputDecoration(
            labelText: 'Department Name',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
