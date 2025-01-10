import 'package:flutter/material.dart';
import 'charts/circular_chart.dart';

class LeaderDashboard extends StatelessWidget {
  const LeaderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the Circular Chart Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CircularChartPage(),
              ),
            );
          },
          child: const Text("View Circular Chart"),
        ),
      ),
    );
  }
}
