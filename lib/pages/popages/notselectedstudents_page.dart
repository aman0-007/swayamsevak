import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/po/addteacher.dart';

class NotSelectedStudents extends StatefulWidget {
  @override
  _NotSelectedStudentsState createState() => _NotSelectedStudentsState();
}

class _NotSelectedStudentsState extends State<NotSelectedStudents> {
  late Future<List<Student>> _students;
  final TeacherService _teacherService = TeacherService();

  @override
  void initState() {
    super.initState();
    _students = _loadStudents();
  }

  Future<List<Student>> _loadStudents() async {
    final clgDbId = await _teacherService.getClgDbId();
    if (clgDbId == null) {
      throw Exception('College Database ID not found');
    }
    return fetchStudents(clgDbId);
  }

  Future<List<Student>> fetchStudents(String clgDbId) async {
    final url = 'http://213.210.37.81:1234/api/students/not-selected/$clgDbId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['message'] == 'Students fetched successfully') {
        final List<dynamic> studentsData = data['students'];
        return studentsData.map((student) => Student.fromJson(student)).toList();
      } else {
        throw Exception('Failed to load students');
      }
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> updateStudentStatus(String clgDbId, String studentId) async {
    final url = 'http://213.210.37.81:1234/api/direct-update-status/$clgDbId/$studentId';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['message'] == 'Status updated successfully') {
        // Refresh the students list
        setState(() {
          _students = fetchStudents(clgDbId);
        });
      } else {
        throw Exception('Failed to update student status');
      }
    } else {
      throw Exception('Failed to update student status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Students Not Selected')),
      body: FutureBuilder<List<Student>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      '${student.name} ${student.surname}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Class: ${student.className}'),
                        Text('Current Year: ${student.currentYear}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.update),
                      onPressed: () => _showConfirmationDialog(context, student),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Show confirmation dialog before updating student status
  void _showConfirmationDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Text('Are you sure you want to update the status of ${student.name} ${student.surname}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final clgDbId = await _teacherService.getClgDbId();
                if (clgDbId != null) {
                  await updateStudentStatus(clgDbId, student.studId);
                  Navigator.pop(context); // Close the dialog
                } else {
                  // Handle error if clgDbId is not found
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: College Database ID not found')),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class Student {
  final String studId;
  final String name;
  final String surname;
  final String className;
  final String currentYear;

  Student({
    required this.studId,
    required this.name,
    required this.surname,
    required this.className,
    required this.currentYear,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studId: json['stud_id'],
      name: json['name'] ?? 'Unknown',
      surname: json['surname'] ?? 'Unknown',
      className: json['class'] ?? 'Unknown',
      currentYear: json['CurrentYear'] ?? 'Unknown',
    );
  }
}
