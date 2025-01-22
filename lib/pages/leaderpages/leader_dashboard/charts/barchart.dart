import 'package:flutter/material.dart';

class BarChart extends StatefulWidget {
  const BarChart({Key? key}) : super(key: key);

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<int> data = [10, 20, 15, 30, 25, 35, 40, 45, 50, 55]; // Data for the bars
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.amber,
    Colors.pink,
    Colors.teal,
    Colors.indigo
  ]; // Color for each bar

  @override
  void initState() {
    super.initState();
    // Animation controller for bar chart drawing animation
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
              return ElevatedBoxWithChart(animation: _animation, data: data, colors: colors);
            },
          ),
        ],
      ),
    );
  }
}

class ElevatedBoxWithChart extends StatelessWidget {
  final Animation<double> animation;
  final List<int> data;
  final List<Color> colors;

  const ElevatedBoxWithChart({Key? key, required this.animation, required this.data, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        width: MediaQuery.of(context).size.width * 0.92, // 92% of the screen width
        height: 400, // Height for the bar chart
        padding: const EdgeInsets.all(12), // Padding for spacing inside the box
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10), // Space between the label and chart
            CustomPaint(
              size: const Size(double.infinity, 300),
              painter: BarChartPainter(animation: animation, data: data, colors: colors),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final Animation<double> animation;
  final List<int> data;
  final List<Color> colors;

  BarChartPainter({required this.animation, required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    // Reduce the bar width (adjusting the factor for a thinner bar)
    double barWidth = size.width / (data.length * 2.13); // Reduced factor for smaller bars
    double maxHeight = size.height - 50; // Leave space for labels

    // Find the maximum data value
    int maxValue = data.reduce((a, b) => a > b ? a : b);

    // Draw the Y-axis and labels
    paint.strokeWidth = 2;
    paint.color = Colors.black;

    // Y-axis line
    canvas.drawLine(Offset(40, 0), Offset(40, size.height - 40), paint);

    // Draw the X-axis line
    canvas.drawLine(Offset(40, size.height - 40), Offset(size.width, size.height - 40), paint);

    // Y-axis Labels (starting from 5)
    drawYAxisLabels(canvas, size, maxHeight, maxValue);

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxValue) * maxHeight * animation.value; // Scale the bar height based on the max value
      paint.color = colors[i];

      // Draw the bar (making bars smaller)
      canvas.drawRect(
        Rect.fromLTWH(i * barWidth * 2.0 + 50, maxHeight - barHeight - 10, barWidth, barHeight), // Adjust y to position bars above x-axis
        paint,
      );
    }

    // Draw the X-axis labels
    drawXAxisLabels(canvas, size);
  }

  // Draw the Y-axis labels starting from 5
  void drawYAxisLabels(Canvas canvas, Size size, double maxHeight, int maxValue) {
    final yAxisLabels = List.generate(7, (index) => ((index + 1) * maxValue) / 7); // Labels based on maxValue
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '5',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    )..layout();
    textPainter.paint(canvas, Offset(10, size.height - 90)); // Y-axis label for 5

    for (int i = 0; i < yAxisLabels.length; i++) {
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: yAxisLabels[i].toStringAsFixed(0), // Display integer values
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      )..layout();
      textPainter.paint(canvas, Offset(10, size.height - 90 - (i * 30))); // Dynamically positioning labels
    }
  }

  void drawXAxisLabels(Canvas canvas, Size size) {
    double space = size.width / (data.length + 1); // Dynamic space for X-axis labels
    for (int i = 0; i < data.length; i++) {
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: 'Month', // Labeling the months
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      )..layout();
      textPainter.paint(canvas, Offset(i * space + 50, size.height - 20)); // Positioning the labels on the x-axis
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
