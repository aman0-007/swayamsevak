import 'package:flutter/material.dart';

class DualColorBarChart extends StatefulWidget {
  const DualColorBarChart({Key? key}) : super(key: key);

  @override
  _DualColorBarChartState createState() => _DualColorBarChartState();
}

class _DualColorBarChartState extends State<DualColorBarChart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Sample data
  final List<int> data1 = [10, 20, 15, 30, 25, 35, 40, 45, 50, 55];
  final List<int> data2 = [5, 10, 8, 15, 12, 17, 20, 23, 25, 27];
  final Color lowerColor = Colors.blue;
  final Color upperColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.92, // 92% width
                height: 400,
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
                padding: const EdgeInsets.all(12),
                child: CustomPaint(
                  painter: DualColorBarChartPainter(
                    animation: _animation,
                    data1: data1,
                    data2: data2,
                    lowerColor: lowerColor,
                    upperColor: upperColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DualColorBarChartPainter extends CustomPainter {
  final Animation<double> animation;
  final List<int> data1;
  final List<int> data2;
  final Color lowerColor;
  final Color upperColor;

  DualColorBarChartPainter({
    required this.animation,
    required this.data1,
    required this.data2,
    required this.lowerColor,
    required this.upperColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double barWidth = (size.width - 50) / (data1.length * 2); // Adjusted bar width
    double maxHeight = size.height - 50; // Leave space for labels and axes

    // Maximum data value for scaling
    int maxValue =
    (data1.reduce((a, b) => a > b ? a : b) + data2.reduce((a, b) => a > b ? a : b));

    // Draw y-axis
    paint.color = Colors.grey;
    paint.strokeWidth = 1.0;
    canvas.drawLine(const Offset(40, 0), Offset(40, maxHeight), paint);

    // Draw x-axis line
    canvas.drawLine(
        Offset(40, maxHeight), Offset(size.width - 10, maxHeight), paint);

    // Draw y-axis labels
    final yStep = maxValue ~/ 5; // Dividing y-axis into 5 steps
    for (int i = 0; i <= 5; i++) {
      double y = maxHeight - (i * (maxHeight / 5));
      final textPainter = TextPainter(
        text: TextSpan(
          text: (i * yStep).toString(),
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(10, y - 6));
      // Draw horizontal line
      paint.color = Colors.grey.shade300;
      canvas.drawLine(Offset(40, y), Offset(size.width - 10, y), paint);
    }

    // Draw the bars
    for (int i = 0; i < data1.length; i++) {
      double x = 50 + i * barWidth * 2;
      double barHeight1 = (data1[i] / maxValue) * maxHeight * animation.value;
      double barHeight2 = (data2[i] / maxValue) * maxHeight * animation.value;

      // Lower section
      paint.color = lowerColor;
      canvas.drawRect(
        Rect.fromLTWH(x, maxHeight - barHeight1, barWidth, barHeight1),
        paint,
      );

      // Upper section
      paint.color = upperColor;
      canvas.drawRect(
        Rect.fromLTWH(
            x, maxHeight - barHeight1 - barHeight2, barWidth, barHeight2),
        paint,
      );

      // Draw data values inside the bars
      final textPainter1 = TextPainter(
        text: TextSpan(
          text: data1[i].toString(),
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter1.paint(canvas,
          Offset(x + barWidth / 4, maxHeight - barHeight1 - 12));

      final textPainter2 = TextPainter(
        text: TextSpan(
          text: data2[i].toString(),
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter2.paint(
          canvas,
          Offset(x + barWidth / 4,
              maxHeight - barHeight1 - barHeight2 - 12));
    }

    // Draw x-axis labels
    for (int i = 0; i < data1.length; i++) {
      double x = 50 + i * barWidth * 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: "Item ${i + 1}",
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - barWidth / 2, maxHeight + 5));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
