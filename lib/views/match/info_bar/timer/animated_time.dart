import 'package:flutter/material.dart';

class AnimatedTime extends StatefulWidget {
  final int minutes;

  AnimatedTime({@required this.minutes});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedTimeState();
  }
}

class _AnimatedTimeState extends State<AnimatedTime>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _animationController.reverse().whenComplete(() {
            if (widget.minutes != 90) _animationController.forward();
          });
      });
    _opacity = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.minutes >= 80 &&
        widget.minutes != 90 &&
        !_animationController.isAnimating) _animationController.forward();
    return Opacity(
      opacity: _opacity.value,
      child: Text(
        '${widget.minutes}\'',
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xff00A8FF),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
