import 'package:flutter/material.dart';
import 'package:swayamsevak/services/po/getpoData.dart'; // Import the POService class
import 'package:swayamsevak/services/po/makeleader.dart';

class AppliedLeadersPage extends StatefulWidget {
  const AppliedLeadersPage({Key? key}) : super(key: key);

  @override
  State<AppliedLeadersPage> createState() => _AppliedLeadersPageState();
}

class _AppliedLeadersPageState extends State<AppliedLeadersPage> {
  final MakeLeaderService _service = MakeLeaderService();
  final POService _poService = POService(); // Instantiate POService
  List<Map<String, String>> _appliedLeaders = [];
  List<Map<String, String>> _teachers = [];
  List<String> _groups = [];
  bool _isLoading = true;

  String? _selectedTeacher;
  String? _selectedGroup;
  String? _clgDbId;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get PO data and extract the clgDbId
      final poData = await _poService.getPOData();
      _clgDbId = poData['clgDbId']!; // Store clgDbId as a member variable

      // Now fetch the leaders, teachers, and groups using the clgDbId
      final leaders = await _service.findAppliedLeaders(_clgDbId!);
      final teachers = await _service.getTeachersAndPositions(_clgDbId!);
      final groups = await _service.getAllGroups(_clgDbId!);

      setState(() {
        _appliedLeaders = leaders;
        _teachers = teachers;
        _groups = groups;
      });
    } catch (e) {
      _showSnackbar(e.toString(), Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateLeader(String studId) async {
    if (_selectedTeacher == null || _selectedGroup == null) {
      _showSnackbar("Please select a teacher and group", Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_clgDbId != null) {
        final success = await _service.updateLeader(
          _clgDbId!,  // Pass clgDbId
          studId,
          _selectedTeacher!,
          _selectedGroup!,
        );

        final message =
        success ? "Updated leader successfully!" : "Failed to update leader";
        _showSnackbar(message, success ? Colors.green : Colors.red);
      } else {
        _showSnackbar("College DB ID is missing", Colors.red);
      }
    } catch (e) {
      _showSnackbar(e.toString(), Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Applied Leaders"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _appliedLeaders.isEmpty
          ? const Center(child: Text("No leaders applied"))
          : ListView.builder(
        itemCount: _appliedLeaders.length,
        itemBuilder: (context, index) {
          final leader = _appliedLeaders[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("${leader['name']} ${leader['surname']}"),
              subtitle: Text("Student ID: ${leader['stud_id']}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showUpdateDialog(leader['stud_id']!);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateDialog(String studId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Leader"),
        content: SingleChildScrollView( // Wrap in SingleChildScrollView to avoid overflow
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Teacher Dropdown
              DropdownButton<String>(
                isExpanded: true,
                hint: Text(_selectedTeacher == null
                    ? "Select Teacher"
                    : "Selected Teacher: ${_teachers.firstWhere((teacher) => teacher['teacher_id'] == _selectedTeacher)['name']}"),
                value: _selectedTeacher,
                items: _teachers.map((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher['teacher_id'],
                    child: Text(teacher['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeacher = value; // Update selected teacher
                  });
                  Navigator.of(context).pop(); // Close dialog to refresh state
                  _showUpdateDialog(studId); // Reopen dialog to show updated state
                },
              ),
              const SizedBox(height: 10),
              // Group Dropdown
              DropdownButton<String>(
                isExpanded: true,
                hint: Text(_selectedGroup == null
                    ? "Select Group"
                    : "Selected Group: $_selectedGroup"),
                value: _selectedGroup,
                items: _groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroup = value; // Update selected group
                  });
                  Navigator.of(context).pop(); // Close dialog to refresh state
                  _showUpdateDialog(studId); // Reopen dialog to show updated state
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateLeader(studId);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
