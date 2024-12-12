import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/services/leader/addevent.dart';
import 'package:swayamsevak/services/leader/getdataLeader.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _venueController;
  late TextEditingController _teacherInChargeController;
  late TextEditingController _projectController;

  List<Map<String, String>> _teachers = [];
  List<Map<String, String>> _projects = [];

  String? _selectedTeacher;
  String? _selectedProject;

  bool _isLoading = false;
  String? clgDbId;  // Declare clgDbId to store the College Database ID

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateController = TextEditingController();
    _venueController = TextEditingController();
    _teacherInChargeController = TextEditingController();
    _projectController = TextEditingController();

    // Fetch the clgDbId before fetching teachers and projects
    _fetchClgDbIdAndData();
  }

  // Fetch the College DB ID and then fetch teachers and projects
  Future<void> _fetchClgDbIdAndData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch leader details (including clgDbId)
      final leaderService = LeaderService();
      final leaderDetails = await leaderService.getLeaderDetails();
      clgDbId = leaderDetails['clgDbId'];  // Get the clgDbId from the leader data

      if (clgDbId != null) {
        // Fetch teachers and projects only if we have clgDbId
        final eventService = LeaderAddEvent();
        final teachers = await eventService.getTeachers(clgDbId!);
        final projects = await eventService.getProjects(clgDbId!);

        setState(() {
          _teachers = teachers;
          _projects = projects;
          _isLoading = false;
        });
      } else {
        throw Exception("College DB ID not found");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackbar("Failed to fetch data: $e", Colors.red);
    }
  }

  // Submit the Event
  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final eventService = LeaderAddEvent();
      final eventData = {
        'name': _nameController.text,
        'date': _dateController.text,
        'level': 'College', // You can modify this as per your need
        'venue': _venueController.text,
        'teacher_incharge': _teacherInChargeController.text,
        'projectName': _projectController.text,
        'leader_id': 'leader123', // Replace this with the actual leader ID
        'currentNssBatch': '2020-2024',
      };

      try {
        final success = await eventService.createEvent(clgDbId!, eventData);
        if (success) {
          _showSnackbar("Event created successfully", Colors.green);
        } else {
          _showSnackbar("Failed to create event", Colors.red);
        }
      } catch (e) {
        _showSnackbar("Error: $e", Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show Snackbar
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextInputField(label: 'Event Name', controller: _nameController),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Event Date (e.g. 2023-12-01T09:00:00Z)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event date';
                  }
                  return null;
                },
              ),
              TextInputField(label: 'Venue', controller: _venueController),
              DropdownButtonFormField<String>(
                items: _teachers
                    .map((teacher) => DropdownMenuItem(
                  value: teacher['teacher_id'],
                  child: Text(teacher['name']!),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeacher = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Teacher'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a teacher';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                items: _projects
                    .map((project) => DropdownMenuItem(
                  value: project['project_id'],
                  child: Text(project['projectName']!),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProject = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Project'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a project';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEvent,
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
