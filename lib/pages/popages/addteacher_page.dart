import 'package:flutter/material.dart';
import 'package:swayamsevak/components/enrollment_page/email_input.dart';
import 'package:swayamsevak/components/enrollment_page/password_input.dart';
import 'package:swayamsevak/components/enrollment_page/snackbar.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/services/po/addteacher.dart';

class AddTeacherPage extends StatefulWidget {
  @override
  _AddTeacherPageState createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedProjectId;
  String? _selectedGroupId;
  List<Map<String, String>> _projects = [];
  List<Map<String, String>> _groups = [];
  final TeacherService _backendService = TeacherService();
  String? _currentNssBatch;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _currentNssBatch = await _backendService.getCurrentNssBatch();
    final clgDbId = await _backendService.getClgDbId();
    if (clgDbId != null) {
      try {
        final projects = await _backendService.fetchProjects(clgDbId);
        final groups = await _backendService.fetchGroups(clgDbId);
        setState(() {
          _projects = projects.map((project) {
            return {
              "id": project["_id"]?.toString() ?? '',
              "name": project["projectName"]?.toString() ?? '',
            };
          }).toList();

          _groups = groups.map((group) {
            return {
              "id": group["_id"]?.toString() ?? '',
              "name": group["name"]?.toString() ?? '',
            };
          }).toList();
        });
      } catch (e) {
        SnackbarHelper.showSnackbar(context: context, message: 'Failed to load data: $e', backgroundColor: Colors.red);
      }
    } else {
      SnackbarHelper.showSnackbar(context: context, message: 'College Database ID not found', backgroundColor: Colors.red);
    }
  }

  Future<void> _submitTeacher() async {
    final clgDbId = await _backendService.getClgDbId();
    if (clgDbId != null) {
      // Generate teacher_id by concatenating name and group
      final teacherName = _nameController.text.trim().toUpperCase();
      final groupName = _groups.firstWhere((group) => group['id'] == _selectedGroupId, orElse: () => {'name': ''})['name']?.toUpperCase() ?? '';
      final teacherId = '$teacherName.$groupName';

      final teacherData = {
        "teacher_id": teacherId,
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "project_id": _selectedProjectId ?? '',
        "currentNssBatch": _currentNssBatch,
        "groupName": groupName,
      };

      try {
        await _backendService.addTeacher(clgDbId, teacherData);
        SnackbarHelper.showSnackbar(context: context, message: 'Teacher added successfully', backgroundColor: Colors.green);
        _clearFields();
      } catch (e) {
        print(teacherData);
        print("-----------------------------------------------");
        SnackbarHelper.showSnackbar(context: context, message: 'Failed to add teacher: $e', backgroundColor: Colors.red);
      }
    } else {
      SnackbarHelper.showSnackbar(context: context, message: 'College Database ID not found', backgroundColor: Colors.red);
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _selectedProjectId = null;
      _selectedGroupId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add Teacher')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputField(
                label: 'Name',
                controller: _nameController,
              ),
              SizedBox(height: 16.0),
              EmailInputField(
                label: 'Email',
                controller: _emailController,
              ),
              SizedBox(height: 16.0),
              PasswordInputField(
                label: 'Password',
                controller: _passwordController,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedProjectId,
                items: _projects
                    .map((project) => DropdownMenuItem(
                  value: project['id'],
                  child: Text(project['name']!),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProjectId = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Project'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedGroupId,
                items: _groups
                    .map((group) => DropdownMenuItem(
                  value: group['id'],
                  child: Text(group['name']!),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Group'),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                onPressed: _submitTeacher,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
