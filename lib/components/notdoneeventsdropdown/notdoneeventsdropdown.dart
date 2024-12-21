import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/leader/getdataLeader.dart';

class NotDoneEventsDropdown extends StatefulWidget {
  final TextEditingController controller;
  final Function(Map<String, dynamic>?) onEventSelected;

  const NotDoneEventsDropdown({
    Key? key,
    required this.controller,
    required this.onEventSelected,
  }) : super(key: key);

  @override
  _NotDoneEventsDropdownState createState() => _NotDoneEventsDropdownState();
}

class _NotDoneEventsDropdownState extends State<NotDoneEventsDropdown> {
  List<Map<String, dynamic>> _dropdownItems = [];
  bool _isLoading = true;
  final LeaderService _leaderService = LeaderService();

  @override
  void initState() {
    super.initState();
    _fetchDropdownItems();
  }

  Future<void> _fetchDropdownItems() async {
    try {
      final leaderDetails = await _leaderService.getLeaderDetails();
      final clgDbId = leaderDetails['clgDbId'];
      final currentNssBatch = leaderDetails['nssBatch'];
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
        SnackBar(content: Text("Errorrrr: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<String>(
      value: _dropdownItems.any((item) => item['event_id'] == widget.controller.text)
          ? widget.controller.text
          : null,
      decoration: InputDecoration(
        labelText: "Select Event",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: _dropdownItems
          .map(
            (item) => DropdownMenuItem<String>(
          value: item['event_id'], // Ensure this matches the DropdownButton value
          child: Text(item['name'] ?? 'Unnamed Event'),
        ),
      )
          .toList(),
      onChanged: (value) {
        final selectedEvent = _dropdownItems.firstWhere(
              (item) => item['event_id'] == value,
          orElse: () => {},
        );
        widget.onEventSelected(selectedEvent.isNotEmpty ? selectedEvent : null);
      },
    );
  }
}
