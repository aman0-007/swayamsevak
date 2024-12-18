import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/po/getpoData.dart';

class NotDoneEventsDropdown extends StatefulWidget {
  final TextEditingController controller;

  const NotDoneEventsDropdown({Key? key, required this.controller}) : super(key: key);

  @override
  _NotDoneEventsDropdownState createState() => _NotDoneEventsDropdownState();
}

class _NotDoneEventsDropdownState extends State<NotDoneEventsDropdown> {
  List<Map<String, dynamic>> _dropdownItems = [];
  bool _isLoading = true;
  final POService _poService = POService();

  @override
  void initState() {
    super.initState();
    _fetchDropdownItems();
  }

  Future<void> _fetchDropdownItems() async {

    try {
      final poDetails = await _poService.getPOData();
      final clgDbId = poDetails['clgDbId'];
      final currentNssBatch = poDetails['currentNssBatch'];
      final apiUrl = "http://213.210.37.81:1234/api/events/active/$clgDbId/$currentNssBatch";
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _dropdownItems = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch dropdown items");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<String>(
      value: widget.controller.text.isNotEmpty ? widget.controller.text : null,
      decoration: InputDecoration(
        labelText: "Select Event",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: _dropdownItems
          .map(
            (item) => DropdownMenuItem<String>(
          value: item['eventId'].toString(),
          child: Text(item['eventName'] ?? 'Unnamed Event', style: theme.textTheme.bodyMedium),
        ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.controller.text = value ?? '';
        });
      },
    );
  }
}
