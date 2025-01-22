import 'dart:math';
import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineAnimation;
  late Animation<double> _opacityAnimation;
  late List<int> data;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    // Initialize the random data
    data = List.generate(12, (index) => random.nextInt(100));

    // Animation controller for line drawing animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation for opacity (fade-in effect)
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
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
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.92, // 92% of the screen width
            height: 300, // Height for the line chart
            decoration: BoxDecoration(
              color: Colors.white, // White background for the container
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Subtle shadow
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _lineAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value, // Apply fade-in effect
                  child: CustomPaint(
                    painter: LineChartPainter(
                      animation: _lineAnimation,
                      data: data,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Animation<double> animation;
  final List<int> data;
  final Random random = Random();

  LineChartPainter({required this.animation, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final paintDot = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.blue, Colors.green],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    double maxHeight = size.height - 40;
    double maxWidth = size.width - 40;

    // Draw the X and Y axes
    paint.color = Colors.black;
    paint.strokeWidth = 2;
    canvas.drawLine(const Offset(40, 0), Offset(40, size.height - 40), paint); // Y-axis
    canvas.drawLine(Offset(40, size.height - 40), Offset(size.width, size.height - 40), paint); // X-axis

    // Draw the points and the line between them
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      double x = 40 + (maxWidth / 11) * i;
      double y = size.height - 40 - (data[i] / 100) * maxHeight;
      points.add(Offset(x, y));

      // Draw points
      canvas.drawCircle(Offset(x, y), 4, paintDot);
    }

    // Draw the line between points with gradient
    for (int i = 0; i < points.length - 1; i++) {
      paint.shader = gradientPaint.shader;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw X-axis labels (Months)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        text: 'Month',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
    for (int i = 0; i < 12; i++) {
      textPainter.text = TextSpan(
        text: (i + 1).toString(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(40 + (maxWidth / 11) * i - 8, size.height - 30)); // Positioning the labels on the x-axis
    }

    // Draw Y-axis labels
    final yAxisLabels = List.generate(6, (index) => (index + 1) * 20); // Labels for 20, 40, 60, etc.
    for (int i = 0; i < yAxisLabels.length; i++) {
      final label = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: yAxisLabels[i].toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      )..layout();
      label.paint(canvas, Offset(10, size.height - 40 - (maxHeight / 5) * i));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
