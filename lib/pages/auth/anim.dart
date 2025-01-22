import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../../theme/myAppTheme.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomTheme.coral.withOpacity(0.6),
                CustomTheme.lightGray,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [_controller.value, 1 - _controller.value],
            ),
          ),
        );
      },
    );
  }
}
