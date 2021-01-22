import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedTime extends StatefulWidget {
  final String label;

  AnimatedTime(Key key, {@required this.label}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimatedTimeState();
  }
}

class _AnimatedTimeState extends State<AnimatedTime>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() => setState(() {}));
    _scale = Tween<double>(begin: 2.5, end: 0).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale.value,
      child: Text(
        widget.label,
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
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

class DecisionTimer extends StatefulWidget {
  final Function hide;
  final Function(int) shoot;
  final bool visible, short;
  final List<String> playerNames;
  final Function(String) showPlayerName;

  DecisionTimer({
    @required this.hide,
    @required this.shoot,
    @required this.visible,
    @required this.short,
    @required this.playerNames,
    @required this.showPlayerName,
  });

  @override
  State<StatefulWidget> createState() {
    return _DecisionTimerState();
  }
}

class _DecisionTimerState extends State<DecisionTimer> {
  UniqueKey _key = UniqueKey();
  int _timeLeft = 5;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.short) _timeLeft = 1;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _key = UniqueKey();
          _timeLeft--;
        });
        if (_timeLeft == 0) {
          timer.cancel();
          if (widget.visible) {
            final random = Random().nextInt(3);
            widget.hide();
            widget.shoot(random);
            widget.showPlayerName(widget.playerNames[random]);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTime(_key, label: '$_timeLeft');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
