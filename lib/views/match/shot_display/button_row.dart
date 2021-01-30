import 'dart:async';

import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/shot_display/bloc/player_name_controller.dart';

class PlayerButton extends StatefulWidget {
  final Function(BuildContext, int) setControllers;
  final Function hideTimer, hideButtons;
  final String name;
  final int index;
  final Function(String) showPlayerName;

  PlayerButton({
    Key key,
    @required this.setControllers,
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

  bool _tapEnabled = true;

  Future<void> keepButton() async {
    _tapEnabled = false;
    await _offsetController.forward();
    Future.delayed(
      const Duration(seconds: 1),
      () => _offsetController.reverse(),
    );
  }

  void hideButton() {
    _tapEnabled = false;
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
          onTap: _tapEnabled
              ? () async {
                  _tapEnabled = false;
                  widget.hideTimer();
                  widget.hideButtons();
                  _offsetController.forward();
                  await widget.setControllers(context, widget.index);
                  widget.showPlayerName(widget.name);
                }
              : null,
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
  final Function(BuildContext, int) setControllers;
  final List<String> names;
  final Function hideTimer;
  final Function(String) showPlayerName;

  ButtonRow({
    @required this.setControllers,
    @required this.names,
    @required this.hideTimer,
    @required this.showPlayerName,
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
    _nameSubscription = PlayerNameController.stream.listen((name) =>
        name.startsWith('KEEP')
            ? _keys[widget.names.indexOf(name.substring(4))]
                .currentState
                .keepButton()
            : _keys[widget.names.indexOf(name)].currentState.hideButton());
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
              setControllers: widget.setControllers,
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
