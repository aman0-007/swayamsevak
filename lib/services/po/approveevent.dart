import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/po/getpoData.dart';

class NotDoneEvents {
  final POService _poService = POService();

  Future<List<Map<String, dynamic>>> fetchNotDoneEvents() async {
    final poDetails = await _poService.getPOData();
    final clgDbId = poDetails['clgDbId'];
    final currentNssBatch = poDetails['currentNssBatch'];

    if (clgDbId == null || currentNssBatch == null) {
      throw Exception("Missing required PO data: clgDbId or currentNssBatch");
    }

    final apiUrl = "http://213.210.37.81:1234/api/events/not-done/$clgDbId/$currentNssBatch";
    print(apiUrl);
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load events: ${response.body}");
    }
  }

  Future<void> updateEventStatus(String eventId) async {
    final poDetails = await _poService.getPOData();
    final clgDbId = poDetails['clgDbId'];
    final apiUrl = "http://213.210.37.81:1234/api/update-event-status/$clgDbId/$eventId";
    print(apiUrl);
    final response = await http.put(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print("Event status updated successfully!");
    } else {
      throw Exception("Failed to update event status: ${response.body}");
    }
  }
}
