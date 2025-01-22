import 'package:flutter/material.dart';
import 'dart:math';

class DonutChart extends StatefulWidget {
  final List<int> data = [
    10, 15, 12, 18, 22, 25, 9, 13, 17, 19, 21, 24
  ]; // Example data for the 12 parts

  DonutChart({Key? key}) : super(key: key);

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward(); // Start the animation when the widget is created

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to generate a shade of blue based on the value
  Color _getBlueShadeForValue(int value, int maxValue) {
    double percentage = value / maxValue; // Percentage of max value
    int index = (percentage * 8).toInt(); // Map percentage to index range 0-8
    List<Color> blueShades = [
      Colors.blue.shade100,
      Colors.blue.shade200,
      Colors.blue.shade300,
      Colors.blue.shade400,
      Colors.blue.shade500,
      Colors.blue.shade600,
      Colors.blue.shade700,
      Colors.blue.shade800,
      Colors.blue.shade900,
    ];
    return blueShades[index]; // Return corresponding shade based on percentage
  }

  @override
  Widget build(BuildContext context) {
    double chartWidth = MediaQuery.of(context).size.width * 0.92;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: chartWidth,
          height: chartWidth, // Ensures the chart is square
          decoration: BoxDecoration(
            color: Colors.white, // Background color for the chart
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: DonutChartPainter(
                  data: widget.data,
                  animation: _animation,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<int> data;
  final Animation<double> animation;

  DonutChartPainter({required this.data, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 3;
    final double innerRadius = radius * 0.6;
    final Offset center = Offset(size.width / 2, size.height / 2);

    int total = data.reduce((a, b) => a + b); // Total sum of data
    int maxValue = data.reduce((a, b) => a > b ? a : b); // Find the max value

    double startAngle = -3.141592653589793 / 2; // Start angle at top
    double sweepAngle = 0.0;

    for (int i = 0; i < data.length; i++) {
      sweepAngle = (data[i] / total) * 2 * 3.141592653589793 * animation.value; // Animate the angle

      final Paint paint = Paint()
        ..color = _getBlueShadeForValue(data[i], maxValue) // Assign color based on value
        ..style = PaintingStyle.fill;

      // Drawing the arc for each part of the donut chart
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Calculate the center angle for the label position
      double labelAngle = startAngle + sweepAngle / 2;
      double labelX = center.dx + (radius - 30) * cos(labelAngle);
      double labelY = center.dy + (radius - 30) * sin(labelAngle);

      // Draw the label (number) for each segment
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: data[i].toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );

      startAngle += sweepAngle; // Update the starting angle for the next part
    }

    // Drawing the hollow center of the donut chart
    final Paint hollowPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, innerRadius, hollowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  // Function to generate a shade of blue based on the value
  Color _getBlueShadeForValue(int value, int maxValue) {
    double percentage = value / maxValue; // Percentage of max value
    int index = (percentage * 8).toInt(); // Map percentage to index range 0-8
    List<Color> blueShades = [
      Colors.blue.shade100,
      Colors.blue.shade200,
      Colors.blue.shade300,
      Colors.blue.shade400,
      Colors.blue.shade500,
      Colors.blue.shade600,
      Colors.blue.shade700,
      Colors.blue.shade800,
      Colors.blue.shade900,
    ];
    return blueShades[index]; // Return corresponding shade based on percentage
  }
}
