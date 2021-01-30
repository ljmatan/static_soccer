import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';

class ScoreDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder(
          stream: ScoreController.stream,
          initialData: {'red': 0, 'blue': 0},
          builder: (context, score) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
