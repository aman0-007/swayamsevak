import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swayamsevak/components/bottomnav/bottomnavigation.dart';
import 'package:swayamsevak/pages/login_page.dart';
import 'package:swayamsevak/router/leaderrouter/routes.dart';
import 'package:swayamsevak/theme/myAppTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CustomTheme.theme,
      routerConfig: router,
      //home: const CheckLoginState(),
    );
  }
}

class CheckLoginState extends StatelessWidget {
  const CheckLoginState({Key? key}) : super(key: key);

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data == true) {
            return const BottomNavApp();
          } else {
            return const LoginPage();
          }
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Theme Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Press Me'),
        ),
      ),
    );
  }
}
