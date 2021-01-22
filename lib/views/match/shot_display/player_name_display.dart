import 'package:flutter/material.dart';

class PlayerNameDisplay extends StatefulWidget {
  final String name;

  PlayerNameDisplay({@required this.name});

  @override
  State<StatefulWidget> createState() {
    return _PlayerNameDisplayState();
  }
}

class _PlayerNameDisplayState extends State<PlayerNameDisplay>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() => setState(() {}));
    _scale = Tween<double>(begin: 0, end: 2).animate(_animationController);
    Future.delayed(const Duration(milliseconds: 200),
        () => _animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1 - _animationController.value,
      child: Transform.scale(
        scale: _scale.value,
        child: Stack(
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
