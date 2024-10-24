import 'package:flutter/material.dart';

import '../../../theme/app_animations.dart';

const heartAnimationInterval = Duration(milliseconds: 10140);

class HeartAnimation extends StatefulWidget {
  final double size;

  const HeartAnimation({super.key, required this.size});

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: heartAnimationInterval);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // When the animation completes, reset it and play it again
        await Future.delayed(heartAnimationInterval);
        // Fix the issue that animate after disposed due to timer
        if (mounted) {
          _controller.reset();
          _controller.forward();
        }
      }
    });
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimations.asset(
      EAppAnim.heart,
      width: widget.size,
      height: widget.size,
      controller: _controller,
      onLoaded: (comp) {
        _controller
          ..duration = comp.duration
          ..forward();
      },
    );
  }
}
