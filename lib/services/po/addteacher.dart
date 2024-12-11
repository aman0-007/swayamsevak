import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeacherService {
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

  Future<List<Map<String, dynamic>>> fetchProjects(String clgDbId) async {
    final response = await http.get(Uri.parse('http://213.210.37.81:1234/api/projects/$clgDbId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data["projects"]);
    } else {
      throw Exception('Failed to fetch projects');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGroups(String clgDbId) async {
    final response = await http.get(Uri.parse('http://213.210.37.81:1234/api/get-all-groups/$clgDbId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data["groups"]);
    } else {
      throw Exception('Failed to fetch groups');
    }
  }

  Future<void> addTeacher(String clgDbId, Map<String, String?> teacherData) async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:1234/api/add-teacher/$clgDbId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(teacherData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add teacher: ${response.body}');
    }
  }
}
