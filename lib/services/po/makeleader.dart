import 'dart:convert';
import 'package:http/http.dart' as http;

class MakeLeaderService {
  final String baseUrl = "http://213.210.37.81:1234/api";

  // Fetching applied leaders
  Future<List<Map<String, String>>> findAppliedLeaders(String clgDbId) async {
    final url = Uri.parse("$baseUrl/find-applied-leaders/$clgDbId");
    print(url);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'appliedLeaders' exists and is a List
        if (data is Map && data.containsKey('appliedLeaders')) {
          final appliedLeaders = data['appliedLeaders'];

          // Check if 'appliedLeaders' is actually a list
          if (appliedLeaders is List) {
            return appliedLeaders.map((leader) {
              return {
                'stud_id': leader['stud_id']?.toString() ?? '',
                'name': leader['name']?.toString() ?? '',
                'surname': leader['surname']?.toString() ?? '',
                'email': leader['email']?.toString() ?? '',
                // Add more fields if required
              };
            }).toList();
          } else {
            throw FormatException('Expected a List under "appliedLeaders", but got ${appliedLeaders.runtimeType}');
          }
        } else {
          throw FormatException('Expected a Map with "appliedLeaders", but got ${data.runtimeType}');
        }
      } else {
        throw Exception("Failed to fetch applied leaders: ${response.body}");
      }
    } catch (e) {
      rethrow; // rethrow the exception to be handled by the caller
    }
  }

  // Fetching teachers and positions
  Future<List<Map<String, String>>> getTeachersAndPositions(String clgDbId) async {
    final url = Uri.parse("$baseUrl/teachers-po/$clgDbId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey("teachersAndPos")) {
          final teachers = data["teachersAndPos"];
          if (teachers is List) {
            return teachers.map((e) => Map<String, String>.from(e)).toList();
          } else {
            throw FormatException('Expected a List under "teachersAndPos", but got ${teachers.runtimeType}');
          }
        } else {
          throw FormatException('Unexpected response structure: ${data.runtimeType}');
        }
      } else {
        throw Exception("Failed to fetch teachers: ${response.body}");
      }
    } catch (e) {
      rethrow; // rethrow the exception to be handled by the caller
    }
  }

  // Fetching all groups
  Future<List<String>> getAllGroups(String clgDbId) async {
    final url = Uri.parse("$baseUrl/get-all-groups/$clgDbId");
    print(url);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the 'groups' field exists and is a List
        if (data['groups'] is List) {
          // Extract the 'name' from each group object
          List<String> groups = (data['groups'] as List)
              .map((group) => group['name'] as String)
              .toList();
          return groups;
        } else {
          throw FormatException('Expected a List of groups, but got ${data['groups'].runtimeType}');
        }
      } else {
        throw Exception("Failed to fetch groups: ${response.body}");
      }
    } catch (e) {
      rethrow; // rethrow the exception to be handled by the caller
    }
  }

  // Updating leader information
  Future<bool> updateLeader(String clgDbId, String studId, String teacherId, String groupName) async {
    final url = Uri.parse("$baseUrl/update-leader/$clgDbId/$studId");

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"teacher_id": teacherId, "group_nm": groupName}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to update leader: ${response.body}");
      }
    } catch (e) {
      rethrow; // rethrow the exception to be handled by the caller
    }
  }
}
