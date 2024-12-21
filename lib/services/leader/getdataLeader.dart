import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderService {
  Future<Map<String, String>> getLeaderDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('user_data');

    if (userDataJson != null) {
      try {
        final userData = jsonDecode(userDataJson);

        if (userData.containsKey('student')) {
          final studentData = userData['student'];

          // Ensure studentData is not null and contains necessary fields
          if (studentData != null) {
            final leaderData = studentData['leader'] ?? {};

            return {
              'clgDbId': userData['clgDbId'] ?? '',
              'stud_id': studentData['stud_id'] ?? '',
              'name': studentData['name'] ?? '',
              'surname': studentData['surname'] ?? '',
              'email': studentData['email'] ?? '',
              'gender': studentData['gender'] ?? '',
              'currentYear': studentData['CurrentYear'] ?? '',
              'isLeader': studentData['is_leader']?.toString() ?? 'no',
              'nssBatch': studentData['currentNssBatch'] ?? '',
              'leader_id': leaderData['leader_id'] ?? '',
              'teacher_id': leaderData['teacher_id'] ?? '',
              'group_nm': leaderData['group_nm'] ?? '',
              'role': leaderData['role'] ?? '',
            };
          } else {
            throw Exception("Student data is missing or null.");
          }
        } else {
          throw Exception("Student data not found in user data.");
        }
      } catch (e) {
        throw Exception("Error parsing leader details: $e");
      }
    } else {
      throw Exception("No user data found in SharedPreferences.");
    }
  }
}
