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
          'clgDbId': poData['clgDbId'].toString(),
          'teacherId': userDetails['teacher_id'].toString(),
          'name': userDetails['name'].toString(),
          'username': userDetails['username'].toString(),
          'email': userDetails['email'].toString(),
          'projectId': userDetails['project_id'].toString(),
          'role': userDetails['role'].join(', ').toString(),
          'currentNssBatch': userDetails['currentNssBatch'].toString(),
          'previousNssBatch': userDetails['previousNssBatch'].join(', ').toString(),
        };
      }
    }

    throw Exception("PO data not found");
  }
}
