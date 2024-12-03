import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  final String baseUrl;

  BackendService(this.baseUrl);

  Future<Map<String, dynamic>> addStudent(String collegeId, Map<String, dynamic> formData) async {
    final url = Uri.parse("$baseUrl/api/add-student/$collegeId");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? "Failed to add student");
    }
  }
}
