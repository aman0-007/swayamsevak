import 'package:flutter/material.dart';
import 'charts/barchart.dart';
import 'charts/circular_chart.dart';
import 'charts/donutchart.dart';
import 'charts/dualcolor_barchart.dart';
import 'charts/linechart.dart';
import 'charts/piechart.dart';
import 'charts/progresslinechart.dart';
import 'charts/singlecolor_barchart.dart'; // Make sure the import path is correct

class LeaderDashboard extends StatelessWidget {
  const LeaderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DonutChart(),
              ProgressLineChart(),
              RadialPieChart(),
              CircularChart(), // Using the CircularChart widget here
              BarChart(),
              LineChart(),
              DualColorBarChart(),
              SingleColorBarChart(),
            ],
          ),
        ),
      ),
    );
  }
}
