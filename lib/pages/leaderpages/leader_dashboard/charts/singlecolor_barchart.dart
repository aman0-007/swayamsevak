import 'package:flutter/material.dart';

class SingleColorBarChart extends StatefulWidget {
  const SingleColorBarChart({Key? key}) : super(key: key);

  @override
  _SingleColorBarChartState createState() => _SingleColorBarChartState();
}

class _SingleColorBarChartState extends State<SingleColorBarChart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Sample data
  final List<int> data = [10, 20, 15, 30, 25, 35, 40, 45, 50, 55];
  final List<Color> barColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
  ];

  int? selectedIndex;

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
              return GestureDetector(
                onTapUp: (_) => setState(() {
                  selectedIndex = null;
                }),
                child: Container(
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
                    painter: SingleColorBarChartPainter(
                      animation: _animation,
                      data: data,
                      barColors: barColors,
                      selectedIndex: selectedIndex,
                    ),
                    child: GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          selectedIndex = calculateTappedBarIndex(
                              details.localPosition, context.size!.width);
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int? calculateTappedBarIndex(Offset position, double containerWidth) {
    double barWidth = (containerWidth - 50) / (data.length * 2);
    for (int i = 0; i < data.length; i++) {
      double xStart = 50 + i * barWidth * 2;
      double xEnd = xStart + barWidth;
      if (position.dx >= xStart && position.dx <= xEnd) {
        return i;
      }
    }
    return null;
  }
}

class SingleColorBarChartPainter extends CustomPainter {
  final Animation<double> animation;
  final List<int> data;
  final List<Color> barColors;
  final int? selectedIndex;

  SingleColorBarChartPainter({
    required this.animation,
    required this.data,
    required this.barColors,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double barWidth = (size.width - 50) / (data.length * 2); // Adjusted bar width
    double maxHeight = size.height - 50; // Leave space for labels and axes

    // Maximum data value for scaling
    int maxValue = data.reduce((a, b) => a > b ? a : b);

    // Draw y-axis
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
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
    }

    // Draw the bars
    for (int i = 0; i < data.length; i++) {
      double x = 50 + i * barWidth * 2;
      double barHeight = (data[i] / maxValue) * maxHeight * animation.value;

      // Bar color
      paint.color = barColors[i % barColors.length];
      canvas.drawRect(
        Rect.fromLTWH(x, maxHeight - barHeight, barWidth, barHeight),
        paint,
      );

      // Highlight the selected bar
      if (selectedIndex == i) {
        paint.color = Colors.black.withOpacity(0.2);
        canvas.drawRect(
          Rect.fromLTWH(x, maxHeight - barHeight, barWidth, barHeight),
          paint,
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: "${data[i]}",
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(x, maxHeight - barHeight - 30));
      }

      // Draw x-axis labels
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
