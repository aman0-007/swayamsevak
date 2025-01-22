import 'package:flutter/material.dart';
import 'dart:math';

class CircularChart extends StatefulWidget {
  const CircularChart({Key? key}) : super(key: key);

  @override
  _CircularChartState createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animation controller for pie chart drawing animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation when the page loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ElevatedBoxWithChart(animation: _animation);
            },
          ),
        ],
      ),
    );
  }
}

class ElevatedBoxWithChart extends StatelessWidget {
  final Animation<double> animation;

  const ElevatedBoxWithChart({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get device width for responsiveness
    double deviceWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.zero, // Remove the default padding
        backgroundColor: Colors.white, // Box background color
        shadowColor: Colors.black, // Shadow color
        elevation: 8, // Box elevation
      ),
      onPressed: () {},
      child: Container(
        width: deviceWidth * 0.92, // Set the width to 92% of device width
        height: 350, // Set the fixed height for the container
        padding: const EdgeInsets.all(12), // Padding for spacing inside the box
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(deviceWidth * 0.92, 180), // The chart will take the width of the container and have a fixed height
              painter: CircularChartPainter(animation: animation),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularChartPainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> data = [40, 30, 20, 10]; // Pie chart data
  final List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.orange]; // Colors for each section
  final List<String> titles = ["40%", "30%", "20%", "10%"]; // Titles for each section

  CircularChartPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    double startAngle = -pi / 2; // Start angle at the top
    double radius = size.width / 3; // Adjust radius to be smaller

    // Draw the sections with animation progress
    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / 100) * 2 * pi * animation.value; // Animate the sweep angle
      paint.color = colors[i];

      // Draw the section
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw the labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: titles[i],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      double textX = size.width / 2 + (radius * 0.7) * cos(startAngle + sweepAngle / 2) - textPainter.width / 2;
      double textY = size.height / 2 + (radius * 0.7) * sin(startAngle + sweepAngle / 2) - textPainter.height / 2;

      textPainter.paint(canvas, Offset(textX, textY));

      startAngle += sweepAngle; // Update the start angle for the next section
    }

    // Draw the hollow center (white circle)
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius / 2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on animation progress update
  }
}
