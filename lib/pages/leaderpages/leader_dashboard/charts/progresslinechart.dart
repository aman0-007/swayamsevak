import 'package:flutter/material.dart';

class ProgressLineChart extends StatefulWidget {
  const ProgressLineChart({Key? key}) : super(key: key);

  @override
  _ProgressLineChartState createState() => _ProgressLineChartState();
}

class _ProgressLineChartState extends State<ProgressLineChart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double _maxProgress = 75.0; // Hardcoded max progress percentage value

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: _maxProgress).animate(
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
    double chartWidth = MediaQuery.of(context).size.width * 0.96; // Increased width to 96% of screen width

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Added padding around the chart
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: chartWidth,
              height: 250, // Height of the chart
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
              child: CustomPaint(
                painter: ProgressLineChartPainter(
                  progress: _animation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProgressLineChartPainter extends CustomPainter {
  final double progress;

  ProgressLineChartPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue, // Start color
          Colors.green, // End color
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8; // Increased stroke width to 8

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8; // Increased stroke width for background

    // Drawing the background line
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), backgroundPaint);

    // Drawing the animated line with the increased width
    double endX = (progress / 100) * size.width;
    canvas.drawLine(Offset(0, size.height / 2), Offset(endX, size.height / 2), linePaint);

    // Text in the center of the line showing the percentage
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: "${progress.toStringAsFixed(1)}%",
        style: TextStyle(
          fontSize: 28, // Increased font size
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Positioning the text a little above the center of the line
    textPainter.paint(
      canvas,
      Offset(endX - textPainter.width / 2, size.height / 2 - textPainter.height - 5), // 5 units above the center
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
