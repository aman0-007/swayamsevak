import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class POService {
  Future<String?> getClgDbId() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final userMap = jsonDecode(userData);
      return userMap['clgDbId'];
    }
    return null;
  }

  Future<String?> getCurrentNssBatch() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final userMap = jsonDecode(userData);
      return userMap['user']?['currentNssBatch'];
    }
    return null;
  }

  Future<void> addPo(String clgDbId, Map<String, String?> teacherData) async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:1234/api/add-po/$clgDbId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(teacherData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add po: ${response.body}');
    }
  }
}
