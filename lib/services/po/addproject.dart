import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectService {
  static Future<String> addProject(String projectName) async {
    try {
      // Retrieve clgDbId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData == null) {
        throw Exception("User data not found in SharedPreferences");
      }

      final decodedData = jsonDecode(userData);
      final clgDbId = decodedData['clgDbId'];
      if (clgDbId == null) {
        throw Exception("ClgID not found in user data");
      }

      // API endpoint
      final url = Uri.parse("http://213.210.37.81:1234/api/create-project/$clgDbId");

      print("++++++++++++++++++++++++++++++++++++++++++++++++" +  clgDbId);
      // Request body
      final requestBody = jsonEncode({
        "projectName": projectName,
      });

      // Make POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      // Handle response
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['message'] ?? "Project added successfully";
      } else {
        throw Exception("Failed to add project: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }
}
