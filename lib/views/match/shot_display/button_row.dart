import 'dart:async';

import 'package:flutter/material.dart';

class PlayerButton extends StatefulWidget {
  final Function(int) setVideo;
  final Function hideTimer, hideButtons;
  final String name;
  final int index;
  final Function(String) showPlayerName;

  PlayerButton({
    Key key,
    @required this.setVideo,
    @required this.hideTimer,
    @required this.hideButtons,
    @required this.name,
    @required this.index,
    @required this.showPlayerName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerButtonState();
  }
}

class _PlayerButtonState extends State<PlayerButton>
    with TickerProviderStateMixin {
  AnimationController _scaleController;
  Animation<double> _scale;
  AnimationController _offsetController;
  Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _scaleController
              .reverse()
              .whenComplete(() => _scaleController.forward());
      });
    _scale = Tween<double>(begin: 0.9, end: 1.1).animate(_scaleController);
    _offsetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _offset = Tween<double>(begin: 0, end: 300).animate(_offsetController);
    _scaleController.forward();
  }

  void keepButton() {
    _offsetController.forward();
    Future.delayed(
      const Duration(seconds: 1),
      () => _offsetController.reverse(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale.value,
      child: Transform.translate(
        offset: Offset(0, -_offset.value),
        child: GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.amber.withOpacity(0.5),
            ),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Center(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            widget.hideButtons();
            keepButton();
            widget.setVideo(widget.index);
            widget.hideTimer();
            widget.showPlayerName(widget.name);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _offsetController.dispose();
    super.dispose();
  }
}

class ButtonRow extends StatefulWidget {
  final Function(int) setVideo;
  final List<String> names;
  final Function hideTimer;
  final Function(String) showPlayerName;
  final Stream nameStream;

  ButtonRow({
    @required this.setVideo,
    @required this.names,
    @required this.hideTimer,
    @required this.showPlayerName,
    @required this.nameStream,
  });

  @override
  State<StatefulWidget> createState() {
    return _ButtonRowState();
  }
}

class _ButtonRowState extends State<ButtonRow>
    with SingleTickerProviderStateMixin {
  AnimationController _offsetController;
  Animation<double> _offset;

  Timer _timer;

  static final GlobalKey<_PlayerButtonState> key1 = GlobalKey();
  static final GlobalKey<_PlayerButtonState> key2 = GlobalKey();
  static final GlobalKey<_PlayerButtonState> key3 = GlobalKey();

  final List<GlobalKey<_PlayerButtonState>> _keys = [key1, key2, key3];

  StreamSubscription _nameSubscription;

  @override
  void initState() {
    super.initState();
    _offsetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() => setState(() {}));
    _offset = Tween<double>(begin: 0, end: 300).animate(_offsetController);
    _timer = Timer(
      const Duration(seconds: 5),
      () => _offsetController.forward(),
    );
    _nameSubscription = widget.nameStream.listen(
        (name) => _keys[widget.names.indexOf(name)].currentState.keepButton());
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _offset.value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 3; i++)
            PlayerButton(
              key: _keys[i],
              index: i,
              setVideo: widget.setVideo,
              hideTimer: widget.hideTimer,
              hideButtons: _offsetController.forward,
              name: widget.names[i],
              showPlayerName: widget.showPlayerName,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _offsetController.dispose();
    _nameSubscription.cancel();
    super.dispose();
  }
}
