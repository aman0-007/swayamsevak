import 'package:flutter/material.dart';
import 'package:swayamsevak/components/login_page/college_dropdown.dart';
import 'package:swayamsevak/components/login_page/dropdown_input.dart';
import 'package:swayamsevak/components/login_page/email_input.dart';
import 'package:swayamsevak/components/login_page/password_input.dart';
import 'package:swayamsevak/components/login_page/text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController studIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedCollege = "Select College";
  String selectedGender = "Male";
  String currentYear = "First";
  String currentNssBatch = "2024-25";

  final List<String> genders = ["Male", "Female", "Other"];
  final List<String> years = ["First", "Second", "Third", "Final"];

  List<String> nssBatches = [];

  @override
  void initState() {
    super.initState();
    _updateNssBatches();
  }

  // Get the current year and generate the NSS batch options
  void _updateNssBatches() {
    final currentYearInt = DateTime.now().year;

    final previousYear = currentYearInt - 1;
    final nextYear = currentYearInt + 1;
    final nextToNextYear = currentYearInt + 2;

    setState(() {
      nssBatches = [
        "$previousYear-$currentYearInt",
        "$currentYearInt-$nextYear",
        "$nextYear-$nextToNextYear"
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String? selectedCollegeId;

    void onCollegeChanged(String? collegeId) {
      setState(() {
        selectedCollegeId = collegeId;
      });

      // Optionally, do something with the selectedCollegeId
      print('Selected College ID: $selectedCollegeId');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CollegeDropdown(onCollegeChanged: onCollegeChanged),
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
              DropdownInputField<String>(
                label: "Current Year",
                items: years,
                selectedValue: currentYear,
                onChanged: (value) => setState(() {
                  currentYear = value!;
                }),
              ),
              const SizedBox(height: 16),
              DropdownInputField<String>(
                label: "Current NSS Batch",
                items: nssBatches,
                selectedValue: currentNssBatch,
                onChanged: (value) => setState(() {
                  currentNssBatch = value!;
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                onPressed: () {
                  // Handle form submission
                  print("Form Submitted!");
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
