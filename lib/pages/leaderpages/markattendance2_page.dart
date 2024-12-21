import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/pages/leaderpages/reviewattendance_page.dart';
import 'dart:convert';

import 'package:swayamsevak/services/leader/getdataLeader.dart';

class AttendanceScan extends StatefulWidget {
  final String leaderId;
  final String eventId;
  final String level;
  final int hours;
  final String position;

  const AttendanceScan({
    super.key,
    required this.leaderId,
    required this.eventId,
    required this.level,
    required this.hours,
    required this.position,
  });

  @override
  State<AttendanceScan> createState() => _AttendanceScanState();
}

class _AttendanceScanState extends State<AttendanceScan> {
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  Map<String, String> attendanceRecords = {};
  bool _isCameraInitialized = false;
  Map<String, String> enrolledStudents = {};
  late Timer _timer;

  List<String> scannedStudentIds = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _fetchEnrolledStudents();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController =
          CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
      await _cameraController.initialize().then((_) {
        setState(() {
          _isCameraInitialized = true;
        });
      });
      _barcodeScanner = BarcodeScanner();
      _startBarcodeScanning();
    } else {
      log('No cameras found');
    }
  }

  void _startBarcodeScanning() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) async {
      if (_cameraController.value.isInitialized) {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          setState(() {
            for (final barcode in barcodes) {
              final studentId = barcode.rawValue;
              if (studentId != null && enrolledStudents.containsKey(studentId)) {
                if (!attendanceRecords.containsKey(studentId)) {
                  final studentName = enrolledStudents[studentId] ?? 'Unknown';
                  attendanceRecords[studentId] = studentName;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Scanned: $studentName',
                        style: Theme.of(context).snackBarTheme.contentTextStyle,
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                    ),
                  );

                  if (!scannedStudentIds.contains(studentId)) {
                    scannedStudentIds.insert(0, studentId); // Insert at the top
                  }
                }
              }
            }
          });
        } else {
          log('No barcode found in the image.');
        }
      }
    });
  }

  Future<void> _fetchEnrolledStudents() async {
    final leaderService = LeaderService();
    final leaderDetails = await leaderService.getLeaderDetails();
    final clgDbId = leaderDetails['clgDbId'];
    final response = await http.get(
      Uri.parse('http://213.210.37.81:1234/api/students/$clgDbId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final students = data['students'] as List;

      setState(() {
        enrolledStudents = {
          for (var student in students)
            student['stud_id']: student['name']
        };
      });
    } else {
      log('Failed to fetch enrolled students, status code: ${response.statusCode}');
    }
  }

  void _removeStudent(String studentId) {
    setState(() {
      attendanceRecords.remove(studentId);
      scannedStudentIds.remove(studentId);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _cameraController.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = enrolledStudents.length;
    final presentStudents = attendanceRecords.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Attendance',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_isCameraInitialized)
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                ),
              )
            else
              const Expanded(
                flex: 2,
                child: Center(child: Text('Loading Camera')),
              ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Leader ID: ${widget.leaderId}',
                                    style: Theme.of(context).textTheme.bodyLarge),
                                Text('Event ID: ${widget.eventId}',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total: $totalStudents',
                                    style: Theme.of(context).textTheme.bodyMedium),
                                Text('Present: $presentStudents',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.green)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        attendanceRecords.isNotEmpty
                            ? Expanded(
                          child: ListView.builder(
                            itemCount: scannedStudentIds.length,
                            itemBuilder: (context, index) {
                              final studentId = scannedStudentIds[index];
                              final studentName =
                                  attendanceRecords[studentId] ?? 'Unknown';
                              return ListTile(
                                title: Text('Student ID: $studentId',
                                    style: Theme.of(context).textTheme.bodyMedium),
                                subtitle: Text('Name: $studentName',
                                    style: Theme.of(context).textTheme.bodySmall),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    _removeStudent(studentId);
                                  },
                                ),
                              );
                            },
                          ),
                        )
                            : const Center(child: Text('No barcodes found')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewAttendancePage(
                          leaderId: widget.leaderId,
                          eventId: widget.eventId,
                          level: widget.level,
                          hours: widget.hours,
                          position: widget.position,
                          attendanceRecords: attendanceRecords,
                        ),
                      ),
                    );
                  },
                  label: const Text('Review Attendance'),
                  icon: const Icon(Icons.check),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
