import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaderAddEvent {
  // Create Event API
  Future<bool> createEvent(String clgDbId, Map<String, String> eventData) async {
    final apiUrl = "http://213.210.37.81:1234/api/create-event/$clgDbId";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['success'] ?? false;
    } else {
      throw Exception("Failed to create event");
    }
  }

  // Fetch List of Teachers API
  Future<List<Map<String, String>>> getTeachers(String clgDbId) async {
    final apiUrl = "http://213.210.37.81:1234/api/teachers-po/$clgDbId";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> teachersList = jsonDecode(response.body);
      return teachersList.map((teacher) {
        return {
          'teacher_id': teacher['teacher_id'] as String,
          'name': teacher['name'] as String,
        };
      }).toList();
    } else {
      throw Exception("Failed to load teachers");
    }
  }

  // Fetch All Projects API
  Future<List<Map<String, String>>> getProjects(String clgDbId) async {
    final apiUrl = "http://213.210.37.81:1234/api/projects/$clgDbId";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> projectsList = jsonDecode(response.body);
      return projectsList.map((project) {
        return {
          'projectName': project['projectName'] as String,
          'project_id': project['project_id'] as String,
        };
      }).toList();
    } else {
      throw Exception("Failed to load projects");
    }
  }
}
