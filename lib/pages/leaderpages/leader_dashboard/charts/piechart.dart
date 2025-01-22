import 'package:flutter/material.dart';

class RadialPieChart extends StatefulWidget {
  const RadialPieChart({Key? key}) : super(key: key);

  @override
  _RadialPieChartState createState() => _RadialPieChartState();
}

class _RadialPieChartState extends State<RadialPieChart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double _percentage = 75.0; // Hardcoded percentage value

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: _percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double chartWidth = MediaQuery.of(context).size.width * 0.92;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
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
                    offset: const Offset(2, 4), // Shadow position
                  ),
                ],
              ),
              child: CustomPaint(
                painter: RadialPieChartPainter(
                  percentage: _animation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RadialPieChartPainter extends CustomPainter {
  final double percentage;

  RadialPieChartPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 3; // Decreased radius
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Background circle
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40; // Increased border width

    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground arc (percentage completed) with purple gradient
    final Paint foregroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFF9C27B0), // Purple shade 1
          Color(0xFF673AB7), // Purple shade 2
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40 // Increased border width to 40
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = (percentage / 100) * 2 * 3.141592653589793;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2, // Start angle at top
      sweepAngle,
      false,
      foregroundPaint,
    );

    // Hollow center
    final Paint centerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - 90, centerPaint);

    // Percentage text
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: "${percentage.toStringAsFixed(1)}%",
        style: const TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
