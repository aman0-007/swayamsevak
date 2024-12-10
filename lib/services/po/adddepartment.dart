import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentService {
  static Future<String> addDepartment(String departmentName, List<String> classes) async {
    try {
      // Retrieve ClgID from SharedPreferences
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
      final url = Uri.parse("http://213.210.37.81:1234/api/add-department/$clgDbId");

      // Request body
      final requestBody = jsonEncode({
        "department_name": departmentName,
        "classes": classes,
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
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message'] ?? "Department added successfully";
      } else {
        throw Exception("Failed to add department: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }
}
