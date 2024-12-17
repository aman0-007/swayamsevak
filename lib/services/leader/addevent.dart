import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaderAddEvent {
  Future<bool> createEvent(String clgDbId, Map<String, String?> eventData) async {
    final apiUrl = "http://213.210.37.81:1234/api/create-event/$clgDbId";
    print("API URL: $apiUrl");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(eventData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final result = jsonDecode(response.body);

        // Check if the message indicates success
        if (result['message'] == "Event created successfully!") {
          return true;
        } else {
          throw Exception("Unexpected response: ${response.body}");
        }
      } else {
        throw Exception("Failed to create event: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Error occurred: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Exception: $e");
    }
  }
}
