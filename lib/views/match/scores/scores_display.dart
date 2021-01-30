import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/scores/bloc/blue_scores_controller.dart';
import 'package:static_soccer/views/match/scores/bloc/red_scores_controller.dart';
import 'package:static_soccer/views/match/scores/bloc/score_model.dart';

class Scores extends StatefulWidget {
  final bool blue;

  Scores({@required this.blue});

  @override
  State<StatefulWidget> createState() {
    return _ScoresState();
  }
}

class _ScoresState extends State<Scores> {
  @override
  void initState() {
    super.initState();
    widget.blue ? BlueScoresController.init() : RedScoresController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: StreamBuilder(
        stream: widget.blue
            ? BlueScoresController.stream
            : RedScoresController.stream,
        builder: (context, scores) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (scores.hasData)
              for (Score score in scores.data)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/ui/name_header.png',
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        '${score.minute}\' ${score.name}',
                        style: const TextStyle(
                          color: Color(0xff092D6F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.blue
        ? BlueScoresController.dispose()
        : RedScoresController.dispose();
    super.dispose();
  }
}
