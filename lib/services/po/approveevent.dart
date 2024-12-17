import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotDoneEvents {
  // Fetch clgDbId and currentNssBatch from SharedPreferences
  Future<Map<String, String>> getLeaderDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('user_data');

    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      final studentData = userData['student'];

      return {
        'clgDbId': userData['clgDbId'],
        'currentNssBatch': studentData['currentNssBatch'],
      };
    }
    throw Exception("Leader data not found");
  }

  // Fetch "Not Done" events from the API
  Future<List<Map<String, dynamic>>> fetchNotDoneEvents() async {
    final leaderDetails = await getLeaderDetails();
    final clgDbId = leaderDetails['clgDbId'];
    final currentNssBatch = leaderDetails['currentNssBatch'];

    final apiUrl = "http://213.210.37.81:1234/api/events/not-done/$clgDbId/$currentNssBatch";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load events: ${response.body}");
    }
  }
}
