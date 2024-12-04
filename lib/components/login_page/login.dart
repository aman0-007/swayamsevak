import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String studentLoginUrl = 'http://213.210.37.81:1234/api/student-login';
  final String teacherLoginUrl = 'http://213.210.37.81:1234/api/teacher-po-login';

  Future<Map<String, dynamic>> attemptLogin(String username, String password) async {
    final urls = [studentLoginUrl, teacherLoginUrl];

    for (final url in urls) {
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'username': username, 'password': password}),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          if (responseBody['message'] == "Login successful") {
            return {
              'success': true,
              'data': responseBody,
            };
          }
        }
      } catch (e) {
        // Log or handle the exception as needed
      }
    }

    return {
      'success': false,
      'error': "Login failed. Please check your credentials.",
    };
  }
}
