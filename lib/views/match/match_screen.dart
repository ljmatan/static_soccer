import 'dart:math';

import 'package:flutter/material.dart';
import 'package:static_soccer/global/values.dart' as global;
import 'package:static_soccer/logic/matchmaking/matchmaking.dart';
import 'package:static_soccer/views/match/bloc/gameplay_controller.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';
import 'package:static_soccer/views/match/continue_button.dart';
import 'package:static_soccer/views/match/info_bar/info_bar.dart';
import 'package:static_soccer/views/match/info_bar/timer/bloc/time_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/timer_display.dart';
import 'package:static_soccer/views/match/scores/scores_display.dart';
import 'package:static_soccer/views/match/shot_display/shot_display.dart';
import 'package:static_soccer/views/match/status_reports/bloc/report_model.dart';
import 'package:static_soccer/views/match/status_reports/bloc/reports_controller.dart';
import 'package:static_soccer/views/match/status_reports/reports_display.dart';

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
    MatchTimeController.init();
    ScoreController.init();
    ReportsController.init();
    while (_redTeamShots.length < widget.shots.redTeamShots) {
      final int minute = 2 + Random().nextInt(86);
      bool acceptable = true;
      for (var shot in _redTeamShots)
        if (minute - 1 == shot ||
            minute + 1 == shot ||
            minute - 2 == shot ||
            minute + 2 == shot) acceptable = false;
      for (var shot in _blueTeamShots) if (minute == shot) acceptable = false;
      if (acceptable) _redTeamShots.add(minute);
    }
    while (_blueTeamShots.length < widget.shots.blueTeamShots) {
      final int minute = 2 + Random().nextInt(86);
      bool acceptable = true;
      for (var shot in _blueTeamShots)
        if (minute - 1 == shot ||
            minute + 1 == shot ||
            minute - 2 == shot ||
            minute + 2 == shot) acceptable = false;
      for (var shot in _redTeamShots) if (minute == shot) acceptable = false;
      if (acceptable) _blueTeamShots.add(minute);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _timerKey.currentState.setShotsNumber(_redTeamShots, _blueTeamShots));
  }

  bool _requiresInput;
  String _mode, _color, _thumbnail;

  void _setInput(bool value) {
    _requiresInput = value;
    _color = value ? 'Blue' : 'Red';
    _mode = global.Values.modes.elementAt(Random().nextInt(6));

    _thumbnail = 'assets/$_mode/${_color}_thumbnail.png';
    GameplayController.change(true);

    Future.delayed(
      const Duration(seconds: 1),
      () => ReportsController.add(
        StatusReport(
          _mode,
          _color,
          _timerKey.currentState.currentTimeInMins,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/ui/bg.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Column(
                children: [
                  InfoBar(_timerKey, setInput: _setInput),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Scores(blue: true),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: StreamBuilder(
                                      stream: ScoreController.stream,
                                      initialData: {'red': 0, 'blue': 0},
                                      builder: (context, score) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            score.data['blue'].toString() +
                                                ' - ' +
                                                score.data['red'].toString(),
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Scores(blue: false),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: StatusReports(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: ContinueButton(),
            ),
            StreamBuilder(
              stream: GameplayController.stream,
              initialData: false,
              builder: (context, displayed) => displayed.data
                  ? VideoDisplay(
                      requiresInput: _requiresInput,
                      mode: _mode,
                      color: _color,
                      thumbnail: _thumbnail,
                      currentTime: _timerKey.currentState.currentTimeInMins,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      onWillPop: () async => _timerKey.currentState.currentTimeInMins == 0,
    );
  }

  @override
  void dispose() {
    GameplayController.dispose();
    MatchTimeController.dispose();
    ScoreController.dispose();
    ReportsController.dispose();
    super.dispose();
  }
}
