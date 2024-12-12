import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class POService {
  Future<Map<String, String>> getPOData() async {
    final prefs = await SharedPreferences.getInstance();
    final poDataJson = prefs.getString('user_data');

    if (poDataJson != null) {
      final poData = jsonDecode(poDataJson);
      if (poData.containsKey('user')) {
        final userDetails = poData['user'];
        return {
          'clgDbId': poData['clgDbId'],
          'teacherId': userDetails['teacher_id'],
          'name': userDetails['name'],
          'username': userDetails['username'],
          'email': userDetails['email'],
          'projectId': userDetails['project_id'],
          'role': userDetails['role'].join(', '),
          'currentNssBatch': userDetails['currentNssBatch'],
          'previousNssBatch': userDetails['previousNssBatch'].join(', '),
        };
      }
    }

    throw Exception("PO data not found");
  }
}
