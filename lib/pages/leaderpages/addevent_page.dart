import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swayamsevak/components/datepicker/fordate.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/components/projectdropdown/projectdropdown.dart';
import 'package:swayamsevak/components/teacherdropdown/teacherdropdown.dart';
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

  final leaderService = LeaderService();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateController = TextEditingController();
    _venueController = TextEditingController();
    _teacherInChargeController = TextEditingController();
    _projectController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // Submit the Event
  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final leaderDetails = await leaderService.getLeaderDetails();
      final clgDbId = leaderDetails['clgDbId'];
      final currentnssbatch = leaderDetails['nssBatch'];
      final leaderId = leaderDetails['leader_id'];

      final eventService = LeaderAddEvent();
      final eventData = {
        'name': _nameController.text,
        'date': _dateController.text,
        'level': 'College',
        'venue': _venueController.text,
        'teacher_incharge': _teacherInChargeController.text,
        'projectName': _projectController.text,
        'leader_id': leaderId,
        'currentNssBatch': currentnssbatch,
      };

      try {
        final success = await eventService.createEvent(clgDbId!, eventData);
        if (success) {

          _showSnackbar("Event created successfully", Colors.green);
          // Clear all fields
          _nameController.clear();
          _dateController.clear();
          _venueController.clear();
          _teacherInChargeController.clear();
          _projectController.clear();
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
              DatePickerWidget(
                dateController: _dateController,
                label: 'Event Date',
              ),
              TextInputField(label: 'Venue', controller: _venueController),
              TeacherDropdownPage(teacherController: _teacherInChargeController),
              ProjectDropdownPage(projectController: _projectController,),
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
