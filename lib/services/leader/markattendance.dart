import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/leader/getdataLeader.dart';

class AttendanceService {
  final leaderService = LeaderService();
  static const String baseUrl = 'http://213.210.37.81:1234';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<List<dynamic>> fetchAllStudents() async {
    try {
      final leaderDetails = await leaderService.getLeaderDetails();
      if (leaderDetails['clgDbId'] == null) {
        throw Exception('clgDbId is missing in leader details');
      }
      final clgDbId = leaderDetails['clgDbId']!;
      print('$baseUrl/api/students/$clgDbId');
      final response = await http.get(
        Uri.parse('$baseUrl/api/students/$clgDbId'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched data: $data');
        if (data['students'] != null) {
          return data['students']! as List;
        } else {
          throw Exception('Failed to fetch students: ${response.body}');
        }
      } else {
        throw Exception('Failed to fetch students.');
      }
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }

  /// Marks attendance.
  Future<bool> markAttendance(Map<String, dynamic> attendanceData) async {
    try {
      final leaderDetails = await leaderService.getLeaderDetails();
      final clgDbId = leaderDetails['clgDbId'];
      print("Attendace Data : $attendanceData");
      print("Marking attendance........................");
      final response = await http.put(
        Uri.parse('$baseUrl/api/mark-attendance/$clgDbId'),
        headers: headers,
        body: jsonEncode(attendanceData),
      );
      print("Attendance marked........................");


      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error marking attendance: $e');
    }
  }
}
