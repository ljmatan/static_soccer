import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';
import 'package:static_soccer/views/match/bloc/gameplay_controller.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';
import 'package:static_soccer/views/match/bloc/timer_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/animated_time.dart';
import 'package:static_soccer/views/match/info_bar/timer/kick_opportunity_dialog.dart';
import 'package:static_soccer/views/match/info_bar/timer/time_controller.dart';

class MatchTimer extends StatefulWidget {
  final Function setControllers, setInput;

  MatchTimer(
    Key key, {
    @required this.setControllers,
    @required this.setInput,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MatchTimerState();
  }
}

class MatchTimerState extends State<MatchTimer> {
  Set<int> _redTeamShots = {};
  Set<int> _blueTeamShots = {};

  void setShotsNumber(Set red, Set blue) {
    _redTeamShots = SplayTreeSet.from(red);
    _blueTeamShots = SplayTreeSet.from(blue);
  }

  int minutesLeft = 0;
  DateTime _paused;

  final DateTime _startTime =
      DateTime.parse(Prefs.instance.getString('matchStart'));

  // You could replace filenames with 0, 1, 2 etc. and remove this parameter from PlayModeButton class
  final List<String> _freeKickPlayers = ['Cris', 'Diego', 'Dinho', 'Leon'];
  final List<String> _crossPlayers = ['Cris', 'Leon', 'Luis', 'Samurai'];
  final List<String> _shootPlayers = ['Cris', 'Diego', 'Dinho', 'Leon'];
  final List<String> _penaltyPlayers = [
    'Cris',
    'Diego',
    'Dinho',
    'Leon'
  ]; // TODO: Update with actual names
  final List<String> _shots = ['Goal1', 'Goal2', 'Hold', 'Miss'];
  final List<String> _modes = [
    'cross',
    'freekick',
    'shoot'
  ]; // TODO: Update with 'penalty'

  Future<void> _startVideo(String color) async {
    widget.setInput(color == 'Blue');

    String video1, video2, video3, video4;

    // TODO: Replace nextInt(3) with nextInt(4) once penalty had been addeds
    final String mode = _modes[Random().nextInt(3)];

    // Block touch events
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (context) => const SizedBox());

    // Add 3 random player vids
    Set<String> _players = {};
    while (_players.length < 3)
      switch (mode) {
        case 'cross':
          _players.add(_crossPlayers[Random().nextInt(4)]);
          break;
        case 'freekick':
          _players.add(_freeKickPlayers[Random().nextInt(4)]);
          break;
        case 'shoot':
          _players.add(_shootPlayers[Random().nextInt(4)]);
          break;
        // TODO: Update for penalty / uncomment below
        /*case 'penalty':
          _players.add(_penaltyPlayers[Random().nextInt(4)]);
          break;*/
      }

    // Assign video values
    video1 =
        'assets/$mode/1_SelectPlayer/${color}_${_players.elementAt(0)}.mp4';
    video2 =
        'assets/$mode/1_SelectPlayer/${color}_${_players.elementAt(1)}.mp4';
    video3 =
        'assets/$mode/1_SelectPlayer/${color}_${_players.elementAt(2)}.mp4';

    final int random = Random().nextInt(10);
    final int shotIndex = random <= 3
        ? 0
        : random > 3 && random <= 6
            ? 1
            : random > 6 && random <= 8
                ? 2
                : 3;
    video4 = 'assets/$mode/2_Result/${color}_${_shots[shotIndex]}.mp4';

    // Initialize videos and their respective controllers
    try {
      await widget.setControllers(video1, video2, video3, video4);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    // Enable touch events
    Navigator.pop(context);

    // Show video display screen
    GameplayController.change(true);
  }

  Timer _timer;
  void _setTimer() => _timer = Timer.periodic(
        const Duration(milliseconds: 333),
        (timer) async {
          minutesLeft += 1;
          if (minutesLeft >= 90) {
            timer.cancel();
            minutesLeft = 90;
          }
          TimeController.change(minutesLeft);
          if (timer.isActive) {
            for (var minute in _blueTeamShots)
              if (minute == minutesLeft) {
                timer.cancel();
                final bool shoot = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => KickDialog(
                    label: 'Goal Scoring Opportunity',
                  ),
                );
                if (shoot) _startVideo('Blue');
              }
            for (var minute in _redTeamShots)
              if (minute == minutesLeft) {
                timer.cancel();
                final bool shoot = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => KickDialog(
                    label: 'Red Team Shoot',
                  ),
                );
                if (shoot) _startVideo('Red');
              }
          }
        },
      );

  StreamSubscription _timerSubscription;

  @override
  void initState() {
    super.initState();
    _setTimer();
    TimerController.init();
    _timerSubscription = TimerController.stream.listen(
      (shotStart) => _setTimer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[2],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        child: StreamBuilder(
          stream: TimeController.stream,
          initialData: minutesLeft,
          builder: (context, minutes) => AnimatedTime(minutes: minutes.data),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timerSubscription.cancel();
    TimerController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
