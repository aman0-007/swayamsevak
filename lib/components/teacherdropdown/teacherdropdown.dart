import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/leader/getdataLeader.dart';

class TeacherDropdownPage extends StatefulWidget {
  final TextEditingController teacherController;

  const TeacherDropdownPage({Key? key, required this.teacherController}) : super(key: key);

  @override
  State<TeacherDropdownPage> createState() => _TeacherDropdownPageState();
}

class _TeacherDropdownPageState extends State<TeacherDropdownPage> {
  List<Map<String, String>> _teachers = [];
  bool _isLoading = true;
  final leaderService = LeaderService();

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    final leaderDetails = await leaderService.getLeaderDetails();
    final clgDbId = leaderDetails['clgDbId'];
    final apiUrl = "http://213.210.37.81:1234/api/teachers-po/$clgDbId";
    print(apiUrl);

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> teachersList = jsonDecode(response.body);
        setState(() {
          _teachers = teachersList
              .map((teacher) => {
            'teacher_id': teacher['teacher_id'].toString(),
            'name': teacher['name'].toString(),
          })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load teachers");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching teachers: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching teachers: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
      value: widget.teacherController.text.isNotEmpty ? widget.teacherController.text : null,
      items: _teachers
          .map(
            (teacher) => DropdownMenuItem(
          value: teacher['teacher_id'],
          child: Text(teacher['name']!),
        ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.teacherController.text = value ?? '';
        });
      },
      decoration: const InputDecoration(labelText: 'Select Teacher'),
      validator: (value) {
        if (value == null) {
          return 'Please select a teacher';
        }
        return null;
      },
    );
  }
}
