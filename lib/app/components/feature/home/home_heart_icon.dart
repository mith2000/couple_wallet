import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../resources/resources.dart';

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
        _controller.reset();
        _controller.forward();
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
    return Lottie.asset(
      R.json.animHeart.path,
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
