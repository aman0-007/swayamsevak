import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaderAddEvent {
  // Create Event API
  Future<bool> createEvent(String clgDbId, Map<String, String?> eventData) async {
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
}
