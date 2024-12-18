import 'package:flutter/material.dart';
import 'package:swayamsevak/components/notdoneeventsdropdown/notdoneeventsdropdown.dart';
import 'package:swayamsevak/components/position/positiondropdown.dart';

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
      appBar: AppBar(title: const Text("Event Details Form")),
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

    final attendanceData = {
      "Event Name": _eventDropdownController.text,
      "Event ID": _eventIdController.text,
      "Leader ID": _leaderIdController.text,
      "Level": _levelController.text,
      "Position": position,
      "Hours": hours,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitPage(attendanceData: attendanceData),
      ),
    );
  }
}



class SubmitPage extends StatelessWidget {
  final Map<String, String> attendanceData;

  const SubmitPage({Key? key, required this.attendanceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Attendance Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: attendanceData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "${entry.key}: ${entry.value}",
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
