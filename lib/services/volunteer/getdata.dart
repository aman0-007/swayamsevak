import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerService {
  Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('user_data');

    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      if (userData.containsKey('student')) {
        final studentData = userData['student'];
        return {
          'clgDbId': userData['clgDbId'] ?? '',
          'stud_id': studentData['stud_id'] ?? '',
          'name': studentData['name'] ?? '',
          'surname': studentData['surname'] ?? '',
          'email': studentData['email'] ?? '',
          'gender': studentData['gender'] ?? '',
          'currentYear': studentData['CurrentYear'] ?? '',
          'isLeader': studentData['is_leader'] ?? '',
          'nssBatch': studentData['currentNssBatch'] ?? '',
        };
      }
    }
    throw Exception("User data not found");
  }

  Future<bool> applyForLeader(String clgDbId, String studId) async {
    final apiUrl = "http://213.210.37.81:1234/api/apply-leader/$clgDbId/$studId";
    print(apiUrl);
    final response = await http.put(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['success'] ?? false;
    } else {
      throw Exception("Failed to apply for leader");
    }
  }
}
