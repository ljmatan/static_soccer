import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/timer.dart';

class InfoBar extends StatelessWidget {
  final GlobalKey timerKey;
  final Function setControllers, setInput;

  InfoBar(
    this.timerKey, {
    @required this.setControllers,
    @required this.setInput,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.of(context).padding.top,
        16,
        16,
      ),
      child: Row(
        children: [
          MatchTimer(
            timerKey,
            setControllers: setControllers,
            setInput: setInput,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Red',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ),
                        Text(
                          Prefs.instance
                              .getDouble('Red Team' + ' strength')
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      child: StreamBuilder(
                        stream: ScoreController.stream,
                        initialData: {'red': 0, 'blue': 0},
                        builder: (context, score) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(score.data['red'].toString()),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Center(
                                  child: SizedBox(width: 0.5, height: 30),
                                ),
                              ),
                            ),
                            Text(score.data['blue'].toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Blue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ),
                        Text(
                          Prefs.instance
                              .getDouble('Blue Team' + ' strength')
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
