import 'package:flutter/material.dart';
import 'package:swayamsevak/components/notdoneeventsdropdown/notdoneeventsdropdown.dart';
import 'package:swayamsevak/components/position/positiondropdown.dart';
import 'package:swayamsevak/pages/leaderpages/markattendance2_page.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({Key? key}) : super(key: key);

  @override
  _MarkAttendancePageState createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  final TextEditingController _eventDropdownController = TextEditingController();
  final TextEditingController _eventIdController = TextEditingController();
  final TextEditingController _leaderIdController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  void _onEventSelected(Map<String, dynamic>? selectedEvent) {
    if (selectedEvent != null) {
      setState(() {
        _eventDropdownController.text = selectedEvent['name'] ?? '';
        _eventIdController.text = selectedEvent['event_id'] ?? '';
        _leaderIdController.text = selectedEvent['leader_id'] ?? '';
        _levelController.text = selectedEvent['level'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: Text(
          'Event Details Form',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      //appBar: AppBar(title: const Text("Event Details Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotDoneEventsDropdown(
              controller: _eventDropdownController,
              onEventSelected: _onEventSelected,
            ),
            const SizedBox(height: 16),
            _buildNonEditableField("Event ID", _eventIdController),
            _buildNonEditableField("Leader ID", _leaderIdController),
            _buildNonEditableField("Level", _levelController),
            PositionDropdown(controller: _positionController),
            _buildEditableField("Hours", _hoursController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitData();
              },
              child: const Text("Mark"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabled: false,
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: label == "Hours" ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  void _submitData() {
    final position = _positionController.text;
    final hours = _hoursController.text;

    if (position.isEmpty || hours.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScan(
          leaderId : _leaderIdController.text,
          eventId : _eventIdController.text,
          position : position,
          level : _levelController.text,
          hours : int.tryParse(hours) ?? 0,
        ),
      ),
    );
  }
}