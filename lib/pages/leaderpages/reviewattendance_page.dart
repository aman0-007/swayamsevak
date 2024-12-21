import 'package:flutter/material.dart';
import 'package:swayamsevak/pages/leaderpages/studentstructure.dart';
import 'package:swayamsevak/services/leader/markattendance.dart';

class ReviewAttendancePage extends StatefulWidget {
  final String leaderId;
  final String eventId;
  final String level;
  final int hours;
  final String position;
  final Map<String, String> attendanceRecords;

  const ReviewAttendancePage({
    super.key,
    required this.leaderId,
    required this.eventId,
    required this.level,
    required this.hours,
    required this.position,
    required this.attendanceRecords,
  });

  @override
  State<ReviewAttendancePage> createState() => _ReviewAttendancePageState();
}

class _ReviewAttendancePageState extends State<ReviewAttendancePage> {
  late AttendanceService _attendanceService;
  List<Student> _students = [];
  Map<String, bool> _selectedStudents = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<String> scannedStudentIds = [];

  @override
  void initState() {
    super.initState();
    _attendanceService = AttendanceService();
    fetchAllStudents();
  }

  void _toggleStudentSelection(String studentId) {
    setState(() {
      _selectedStudents[studentId] = !(_selectedStudents[studentId] ?? false);
      if (_selectedStudents[studentId]!) {
        scannedStudentIds.add(studentId); // Add to scannedStudentIds if selected
      } else {
        scannedStudentIds.remove(studentId);
      }
    });
  }

  Future<void> fetchAllStudents() async {
    try {
      print("Fetching all students...");
      final studentData = await _attendanceService.fetchAllStudents();
      if (studentData is List) {
        setState(() {
          _students = studentData.map((json) {
            if (json is Map<String, dynamic>) {
              return Student.fromJson(json);
            } else {
              throw Exception('Invalid student data format: $json');
            }
          }).toList();
          _selectedStudents = {
            for (var student in _students)
              student.studId: widget.attendanceRecords.containsKey(student.studId),
          };
          scannedStudentIds = widget.attendanceRecords.keys.toList();
        });
      } else {
        throw Exception('Unexpected response format: Expected a List');
      }
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        _students = [];
      });
    }
  }

  List<Student> _getSortedStudents() {
    final selectedStudents = _students.where((student) => _selectedStudents[student.studId] ?? false).toList();
    final unselectedStudents = _students.where((student) => !(_selectedStudents[student.studId] ?? false)).toList();

    unselectedStudents.sort((a, b) => '${a.name} ${a.surname}'.compareTo('${b.name} ${b.surname}'));
    return [...selectedStudents, ...unselectedStudents];
  }

  Future<void> markAttendance() async {
    print("scanned students ids : $scannedStudentIds");
    final attendanceData = {
      'leaderId': widget.leaderId,
      'event_id': widget.eventId,
      'position': widget.position,
      'level': widget.level,
      'hrs': widget.hours,
      'studentIds': scannedStudentIds,
    };

    try {
      bool success = await _attendanceService.markAttendance(attendanceData);
      if (success) {
        // Show success message or perform any necessary action
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Attendance marked successfully'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to mark attendance.');
      }
    } catch (e) {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _getSortedStudents().where((student) {
      final fullName = '${student.name} ${student.surname}'.toLowerCase();
      return fullName.contains(_searchQuery.toLowerCase()) ||
          student.studId.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Attendance'),
        backgroundColor: Colors.blueAccent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name or ID',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoText('Leader ID: ${widget.leaderId}'),
            _buildInfoText('Event: ${widget.eventId}'),
            _buildInfoText('Level: ${widget.level}'),
            _buildInfoText('Hours: ${widget.hours}'),
            _buildInfoText('Position: ${widget.position}'),
            const Divider(),
            _students.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  final isSelected = _selectedStudents[student.studId] ?? false;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${student.name} ${student.surname}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Student ID: ${student.studId}'),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            _toggleStudentSelection(student.studId);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await confirmAndMarkAttendance();
        },
        label: const Text('Mark'), // Updated label
        backgroundColor: Colors.blueAccent, // Use the primary color
        tooltip: 'Mark Attendance',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the button
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black)),
    );
  }

  Future<void> confirmAndMarkAttendance() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Attendance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to mark attendance for the selected students?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without taking action
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await markAttendance(); // Call the attendance marking function
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Use primary color
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
