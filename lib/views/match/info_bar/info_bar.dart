import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/bloc/timer_controller.dart';
import 'package:static_soccer/views/match/info_bar/name_and_strength/name_and_strength.dart';
import 'package:static_soccer/views/match/info_bar/timer/bloc/time_controller.dart';
import 'package:static_soccer/views/match/info_bar/timer/timer_display.dart';

class InfoBar extends StatelessWidget {
  final GlobalKey timerKey;
  final Function setInput;

  InfoBar(this.timerKey, {@required this.setInput});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16 + MediaQuery.of(context).padding.top, 16, 16),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const SizedBox(height: 70),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/ui/cup.png', height: 26),
                              Text(
                                '1613',
                                style: const TextStyle(
                                  color: Color(0xfff3bd15),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/ui/cup.png', height: 26),
                              Text(
                                '1864',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfff3bd15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.asset(
                        'assets/ui/name_header.png',
                        width: MediaQuery.of(context).size.width,
                      ),
                      NameAndStrength(left: true),
                      NameAndStrength(left: false),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 40,
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/ui/timer.png',
                          fit: BoxFit.contain,
                          width: 48,
                          height: 48,
                        ),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: StreamBuilder(
                            stream: MatchTimeController.stream,
                            initialData: 0,
                            builder: (context, time) =>
                                CircularProgressIndicator(
                              value: (90 - time.data) / 90,
                              valueColor: AlwaysStoppedAnimation(
                                const Color(0xff00A8FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: MatchTimer(timerKey, setInput: setInput),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
