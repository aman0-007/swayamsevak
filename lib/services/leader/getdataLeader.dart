import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderService {
  // Fetch leader data from SharedPreferences
  Future<Map<String, String>> getLeaderDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('user_data');

    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      if (userData.containsKey('student')) {
        final studentData = userData['student'];
        final leaderData = studentData['leader'] ?? {};

        return {
          'clgDbId': userData['clgDbId'],
          'stud_id': studentData['stud_id'],
          'name': studentData['name'],
          'surname': studentData['surname'],
          'email': studentData['email'],
          'gender': studentData['gender'],
          'currentYear': studentData['CurrentYear'],
          'isLeader': studentData['is_leader'],
          'nssBatch': studentData['currentNssBatch'],
          'leader_id': leaderData['leader_id'] ?? '',
          'teacher_id': leaderData['teacher_id'] ?? '',
          'group_nm': leaderData['group_nm'] ?? '',
          'role': leaderData['role'] ?? '',
        };
      }
    }
    throw Exception("Leader data not found");
  }
}
