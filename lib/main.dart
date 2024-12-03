import 'package:flutter/material.dart';
import 'package:swayamsevak/pages/enrollment_page.dart';
import 'package:swayamsevak/theme/myAppTheme.dart';

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
      theme: CustomTheme.theme,  // Use the custom theme here
      home: const EnrollmentPage(),
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
