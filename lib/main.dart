import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swayamsevak/components/bottomnav/bottomnavigation.dart';
import 'package:swayamsevak/components/bottomnav/leaderbottomnavigation.dart';
import 'package:swayamsevak/components/bottomnav/studentnavigation.dart';
import 'package:swayamsevak/pages/login_page.dart';
import 'package:swayamsevak/router/leaderrouter/routes.dart';
import 'package:swayamsevak/theme/myAppTheme.dart';

import 'pages/auth/authoption.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CustomTheme.theme,
      // routerConfig: router,
      home: const CheckLoginState(),
    );
  }
}

class CheckLoginState extends StatelessWidget {
  const CheckLoginState({Key? key}) : super(key: key);

  Future<String> _getRole() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if logged in
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      return 'login';
    }

    // Fetch user data from SharedPreferences
    final userDataJson = prefs.getString('user_data');
    if (userDataJson == null) {
      return 'login';
    }

    final userData = jsonDecode(userDataJson);

    if (userData.containsKey('student')) {
      // User is a student
      final studentData = userData['student'];
      final isLeader = studentData['is_leader']?.toLowerCase() == 'yes';
      return isLeader ? 'leader' : 'volunteer';
    } else if (userData.containsKey('user')) {
      // User is a teacher
      final teacherData = userData['user'];
      final roles = teacherData['role'] as List<dynamic>?;
      if (roles != null && roles.contains('PO')) {
        return 'PO';
      } else if (roles != null && roles.isNotEmpty) {
        return roles.first; // Return the first role
      }
    }
    return 'login';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == 'login') {
          return const AuthPage();
        } else {
          final role = snapshot.data;

          switch (role) {
            case 'leader':
              return const LeaderBottomNavApp();
            case 'volunteer':
              return const StudentBottomNavApp();
            case 'PO':
              return const POBottomNavApp();
            case 'Teacher In Charge':
              return const POBottomNavApp();
            default:
              return const POBottomNavApp();
          }
        }
      },
    );
  }
}