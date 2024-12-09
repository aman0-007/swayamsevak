import 'package:flutter/material.dart';
import 'package:swayamsevak/components/enrollment_page/backend/enroll.dart';
import 'package:swayamsevak/components/enrollment_page/college_dropdown.dart';
import 'package:swayamsevak/components/enrollment_page/department_dropdown.dart';
import 'package:swayamsevak/components/enrollment_page/dropdown_input.dart';
import 'package:swayamsevak/components/enrollment_page/email_input.dart';
import 'package:swayamsevak/components/enrollment_page/password_input.dart';
import 'package:swayamsevak/components/enrollment_page/text_input.dart';
import 'package:swayamsevak/components/enrollment_page/nss_batch_dropdown.dart';
import 'package:swayamsevak/components/enrollment_page/year_dropdown.dart';
import 'package:swayamsevak/pages/login_page.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({Key? key}) : super(key: key);

  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  final TextEditingController studIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedCollege = "Select College";
  String selectedGender = "Male";
  // String currentYear = "First";
  late String currentNssBatch;
  String? selectedCollegeId;
  String selectedDepartment = "Select Department";
  String? selectedYear;

  final List<String> genders = ["Male", "Female", "Other"];
  final BackendService backendService = BackendService("http://213.210.37.81:1234");

  @override
  void initState() {
    super.initState();
    currentNssBatch = _generateDefaultBatch();
  }

  String _generateDefaultBatch() {
    final currentYearInt = DateTime.now().year;
    return "$currentYearInt-${currentYearInt + 1}";
  }

  Future<void> _handleSubmit() async {
    final formData = {
      "stud_id": studIdController.text.trim(),
      "name": nameController.text.trim().toUpperCase(),
      "surname": surnameController.text.trim().toUpperCase(),
      "email": emailController.text.trim().toUpperCase(),
      "gender": selectedGender.trim().toUpperCase(),
      "password": passwordController.text.trim(),
      "CurrentYear": selectedYear ?? "",
      "currentNssBatch": currentNssBatch,
      "class": selectedDepartment,
    };

    if (selectedYear == null ||
        selectedYear == "" ||
        selectedCollege == "" || // Ensure selectedCollege is not empty
        formData.values.any((value) => value.isEmpty)) {
      _showSnackbar("other out all fields", Colors.red);
      return;
    }
    try {
      final response = await backendService.addStudent(selectedCollegeId!, formData);
      _showSnackbar(response['message'] ?? "Student added successfully", Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      _showSnackbar("An error occurred: $e", Colors.red);
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Callback function for year selection
  void _onYearChanged(String? year) {
    setState(() {
      selectedYear = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enrollment Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CollegeDropdown(
                onCollegeChanged: (collegeId) {
                  setState(() {
                    selectedCollegeId = collegeId; // Update the selectedCollegeId here
                  });
                },
              ),
              const SizedBox(height: 16),
              // Only show the DepartmentDropdown if selectedCollegeId is not null
              if (selectedCollegeId != null)
                DepartmentDropdown(
                  collegeId: selectedCollegeId!,
                  onDepartmentChanged: (department) {
                    setState(() {
                      selectedDepartment = department ?? "Select Department";
                    });
                  },
                ),
              if (selectedCollegeId != null && selectedDepartment != "Select Department")
                YearDropdown(
                  collegeId: selectedCollegeId!,
                  departmentName: selectedDepartment,
                  onYearChanged: _onYearChanged, // Pass the callback function
                ),
              const SizedBox(height: 16),
              TextInputField(label: "Student ID", controller: studIdController),
              const SizedBox(height: 16),
              TextInputField(label: "Name", controller: nameController),
              const SizedBox(height: 16),
              TextInputField(label: "Surname", controller: surnameController),
              const SizedBox(height: 16),
              EmailInputField(label: "Email", controller: emailController),
              const SizedBox(height: 16),
              DropdownInputField<String>(
                label: "Gender",
                items: genders,
                selectedValue: selectedGender,
                onChanged: (value) => setState(() {
                  selectedGender = value!;
                }),
              ),
              const SizedBox(height: 16),
              PasswordInputField(
                label: "Password",
                controller: passwordController,
              ),
              const SizedBox(height: 16),
              NssBatchDropdown(
                selectedBatch: currentNssBatch,
                onBatchChanged: (value) => setState(() {
                  currentNssBatch = value!;
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                onPressed: _handleSubmit,
                child: const Text("Enroll"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
