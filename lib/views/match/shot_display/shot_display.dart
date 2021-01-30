import 'dart:async';

import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/shot_display/bloc/player_name_controller.dart';
import 'package:static_soccer/views/match/shot_display/bloc/timer_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:static_soccer/logic/gameplay/outcome.dart';
import 'package:static_soccer/views/match/shot_display/button_row.dart';
import 'package:static_soccer/views/match/shot_display/player_name_display.dart';
import 'package:static_soccer/views/match/shot_display/animated_time.dart';

class VideoDisplay extends StatefulWidget {
  final bool requiresInput;
  final String mode, color, thumbnail;
  final int currentTime;

  VideoDisplay({
    @required this.requiresInput,
    @required this.mode,
    @required this.color,
    @required this.thumbnail,
    @required this.currentTime,
  });

  @override
  State<StatefulWidget> createState() {
    return _VideoDisplayState();
  }
}

class _VideoDisplayState extends State<VideoDisplay>
    with SingleTickerProviderStateMixin {
  AnimationController _displayController;
  Animation<double> _scale;

  // Contains string values of player names
  Set<String> _players = {};
  List<String> get players => _players.toList();

  @override
  void initState() {
    super.initState();

    _displayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() => setState(() {}));
    _scale = Tween<double>(begin: 0.1, end: 1).animate(_displayController);

    DecisionTimerController.init();
    PlayerNameController.init();

    _displayController.forward();

    // Set _players object
    Outcome.setPlayers(_players, widget.mode);
  }

  VideoPlayerController _playerController, _shotController;
  final StreamController _viewController = StreamController.broadcast();

  // Set video player controllers and videos. Updates the view and score, and disposes
  // both of the controllers.
  Future<void> _setControllers(BuildContext context, int index) =>
      Outcome.setControllers(
        context,
        index,
        widget.mode,
        widget.color,
        _players,
        _viewController,
        _playerController,
        _shotController,
        _displayController,
        widget.currentTime,
      );

  void _hideTimer() => DecisionTimerController.display(false);

  void _showPlayerName(String name) => PlayerNameController.display(name);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: _displayController.value,
          child: Transform.scale(
            scale: _scale.value,
            child: StreamBuilder(
              stream: _viewController.stream,
              builder: (context, controller) => !controller.hasData
                  ? Image.asset(
                      widget.thumbnail,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    )
                  : SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.data.value.size?.width ?? 0,
                          height: controller.data.value.size?.height ?? 0,
                          child: VideoPlayer(controller.data),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Center(
          child: StreamBuilder(
            stream: DecisionTimerController.stream,
            initialData: true,
            builder: (context, visible) => AnimatedOpacity(
              opacity: visible.data ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: DecisionTimer(
                hide: _hideTimer,
                setControllers: _setControllers,
                visible: visible.data,
                short: !widget.requiresInput,
                playerNames: players,
                showPlayerName: _showPlayerName,
              ),
            ),
          ),
        ),
        Center(
          child: StreamBuilder(
            stream: PlayerNameController.stream,
            builder: (context, name) => name.hasData
                ? PlayerNameDisplay(
                    name: name.data.startsWith('KEEP')
                        ? name.data.substring(4)
                        : name.data)
                : const SizedBox(),
          ),
        ),
        if (widget.requiresInput)
          Positioned(
            bottom: MediaQuery.of(context).size.height / 10,
            left: 16,
            right: 16,
            child: ButtonRow(
              setControllers: _setControllers,
              names: players,
              hideTimer: _hideTimer,
              showPlayerName: _showPlayerName,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    DecisionTimerController.dispose();
    PlayerNameController.dispose();
    _viewController.close();
    super.dispose();
  }
}
