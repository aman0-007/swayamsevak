import 'package:flutter/material.dart';
import 'package:swayamsevak/components/enrollment_page/email_input.dart';
import 'package:swayamsevak/components/enrollment_page/password_input.dart';
import 'package:swayamsevak/components/enrollment_page/snackbar.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/services/po/addpo.dart';
import 'package:swayamsevak/services/po/addteacher.dart';

class AddPoPage extends StatefulWidget {
  @override
  _AddPoPageState createState() => _AddPoPageState();
}

class _AddPoPageState extends State<AddPoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final POService _backendService = POService();
  String? _currentNssBatch;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _currentNssBatch = await _backendService.getCurrentNssBatch();
    final clgDbId = await _backendService.getClgDbId();
  }

  Future<void> _submitTeacher() async {
    final clgDbId = await _backendService.getClgDbId();
    if (clgDbId != null) {
      // Generate teacher_id by concatenating name and group
      final teacherName = _nameController.text.trim().toUpperCase();
      final teacherId = '$teacherName';

      final poData = {
        "teacher_id": teacherId,
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "currentNssBatch": _currentNssBatch,
      };

      try {
        await _backendService.addPo(clgDbId, poData);
        SnackbarHelper.showSnackbar(context: context, message: 'PO added successfully', backgroundColor: Colors.green);
        _clearFields();
      } catch (e) {
        print(poData);
        SnackbarHelper.showSnackbar(context: context, message: 'Failed to add PO: $e', backgroundColor: Colors.red);
      }
    } else {
      SnackbarHelper.showSnackbar(context: context, message: 'College Database ID not found', backgroundColor: Colors.red);
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
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
