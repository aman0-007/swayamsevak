import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http; // For API call
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swayamsevak/components/enrollment_page/snackbar.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _addGroup() async {
    final groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      setState(() {
        _errorText = "Group name cannot be empty";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData == null) {
        throw Exception("User data not found");
      }

      final clgDbId = jsonDecode(userData)['clgDbId'];
      final response = await _sendAddGroupRequest(clgDbId, groupName);

      if (response.statusCode == 201) {
        SnackbarHelper.showSnackbar(
          context: context,
          message: "Group added successfully!",
          backgroundColor: Colors.green,
        );
        _groupNameController.clear();
      } else {
        SnackbarHelper.showSnackbar(
          context: context,
          message: "Failed to add group: ${response.body}",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      SnackbarHelper.showSnackbar(
        context: context,
        message: "Error: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<http.Response> _sendAddGroupRequest(String clgDbId, String groupName) {
    const urlTemplate = "http://213.210.37.81:1234/api/add-group/:clgDbId";
    final url = urlTemplate.replaceFirst(":clgDbId", clgDbId);

    return http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": groupName}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextInputField(
              label: "Group Name",
              controller: _groupNameController,
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _addGroup,
              child: _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
                  : const Text("Add Group"),
            ),
          ],
        ),
      ),
    );
  }
}
