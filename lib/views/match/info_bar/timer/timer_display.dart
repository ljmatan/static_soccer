import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/bloc/timer_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/animated_time.dart';
import 'package:static_soccer/views/match/info_bar/timer/bloc/time_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/kick_opportunity_dialog.dart';

class MatchTimer extends StatefulWidget {
  final Function setInput;

  MatchTimer(Key key, {@required this.setInput}) : super(key: key);

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

  int currentTimeInMins = 0;

  Timer _timer;
  void _setTimer() => _timer = Timer.periodic(
        const Duration(milliseconds: 333),
        (timer) async {
          // Increment time by a minute each 1/3 of a second
          currentTimeInMins += 1;
          if (currentTimeInMins >= 90) {
            timer.cancel();
            currentTimeInMins = 90;
          }
          MatchTimeController.change(currentTimeInMins);
          if (timer.isActive) {
            for (var minute in _blueTeamShots)
              if (minute == currentTimeInMins) {
                timer.cancel();
                // Displays a dialog which
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => KickDialog(
                    label: 'Goal Scoring Opportunity',
                  ),
                );
                widget.setInput(true);
              }
            for (var minute in _redTeamShots)
              if (minute == currentTimeInMins) {
                timer.cancel();
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => KickDialog(
                    label: 'Red Team Shoot',
                  ),
                );
                widget.setInput(false);
              }
          }
        },
      );

  StreamSubscription _timerSubscription;

  @override
  void initState() {
    super.initState();
    _setTimer();
    TimerActivityController.init();
    _timerSubscription = TimerActivityController.stream.listen(
      (shotStart) => _setTimer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MatchTimeController.stream,
      initialData: currentTimeInMins,
      builder: (context, minutes) => AnimatedTime(minutes: minutes.data),
    );
  }

  @override
  void dispose() {
    _timerSubscription.cancel();
    TimerActivityController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
