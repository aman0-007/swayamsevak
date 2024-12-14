import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swayamsevak/services/leader/getdataLeader.dart';

class ProjectDropdownPage extends StatefulWidget {
  final TextEditingController projectController;

  const ProjectDropdownPage({Key? key, required this.projectController}) : super(key: key);

  @override
  State<ProjectDropdownPage> createState() => _ProjectDropdownPageState();
}

class _ProjectDropdownPageState extends State<ProjectDropdownPage> {
  List<Map<String, String>> _projects = [];
  bool _isLoading = true;
  final leaderService = LeaderService();


  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    final leaderDetails = await leaderService.getLeaderDetails();
    final clgDbId = leaderDetails['clgDbId'];
    final apiUrl = "http://213.210.37.81:1234/api/projects/$clgDbId";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> projectsList = jsonDecode(response.body);
        setState(() {
          _projects = projectsList
              .map((project) => {
            'project_id': project['project_id'].toString(),
            'projectName': project['projectName'].toString(),
          })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load projects");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching projects: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
      value: widget.projectController.text.isNotEmpty ? widget.projectController.text : null,
      items: _projects
          .map(
            (project) => DropdownMenuItem(
          value: project['project_id'],
          child: Text(project['projectName']!),
        ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.projectController.text = value ?? '';
        });
      },
      decoration: const InputDecoration(labelText: 'Select Project'),
      validator: (value) {
        if (value == null) {
          return 'Please select a project';
        }
        return null;
      },
    );
  }
}
