import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:static_soccer/logic/matchmaking/matchmaking.dart';
import 'package:static_soccer/views/match/bloc/gameplay_controller.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';
import 'package:static_soccer/views/match/continue_button.dart';
import 'package:static_soccer/views/match/info_bar/info_bar.dart';
import 'package:static_soccer/views/match/info_bar/timer/time_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/timer.dart';
import 'package:static_soccer/views/match/shot_display/shot_display.dart';
import 'package:video_player/video_player.dart';

class MatchScreen extends StatefulWidget {
  final Shots shots;

  MatchScreen({@required this.shots});

  @override
  State<StatefulWidget> createState() {
    return _MatchScreenState();
  }
}

class _MatchScreenState extends State<MatchScreen> {
  final GlobalKey<MatchTimerState> _timerKey = GlobalKey();

  Set<int> _redTeamShots = {};
  Set<int> _blueTeamShots = {};

  @override
  void initState() {
    super.initState();
    GameplayController.init();
    TimeController.init();
    ScoreController.init();
    while (_redTeamShots.length < widget.shots.redTeamShots) {
      final int minute = 2 + Random().nextInt(86);
      bool acceptable = true;
      for (var shot in _redTeamShots)
        if (minute - 1 == shot || minute + 1 == shot) acceptable = false;
      for (var shot in _blueTeamShots) if (minute == shot) acceptable = false;
      if (acceptable) _redTeamShots.add(minute);
    }
    while (_blueTeamShots.length < widget.shots.blueTeamShots) {
      final int minute = 2 + Random().nextInt(86);
      bool acceptable = true;
      for (var shot in _blueTeamShots)
        if (minute - 1 == shot || minute + 1 == shot) acceptable = false;
      for (var shot in _redTeamShots) if (minute == shot) acceptable = false;
      if (acceptable) _blueTeamShots.add(minute);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _timerKey.currentState.setShotsNumber(_redTeamShots, _blueTeamShots));
  }

  VideoPlayerController _controller1;
  VideoPlayerController _controller2;
  VideoPlayerController _controller3;
  VideoPlayerController _controller4;

  // Assign video values to their respective controllers
  Future<void> _setControllers(
    String video1,
    String video2,
    String video3,
    String video4,
  ) async {
    _controller1 = VideoPlayerController.asset(video1);
    _controller2 = VideoPlayerController.asset(video2);
    _controller3 = VideoPlayerController.asset(video3);
    _controller4 = VideoPlayerController.asset(video4);
    await _controller1.initialize();
    await _controller2.initialize();
    await _controller3.initialize();
    await _controller4.initialize();
  }

  void _disposeControllers() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
  }

  bool _requiresInput;
  void _setInput(bool value) => _requiresInput = value;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                InfoBar(
                  _timerKey,
                  setControllers: _setControllers,
                  setInput: _setInput,
                ),
              ],
            ),
            ContinueButton(),
            StreamBuilder(
              stream: GameplayController.stream,
              initialData: false,
              builder: (context, displayed) => displayed.data
                  ? VideoDisplay(
                      playerList: [
                        _controller1,
                        _controller2,
                        _controller3,
                      ],
                      shotController: _controller4,
                      dispose: _disposeControllers,
                      requiresInput: _requiresInput,
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
      onWillPop: () async => _timerKey.currentState.minutesLeft == 0,
    );
  }

  @override
  void dispose() {
    GameplayController.dispose();
    TimeController.dispose();
    ScoreController.dispose();
    super.dispose();
  }
}
