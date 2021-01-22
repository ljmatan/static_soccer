import 'dart:math';

import 'package:flutter/widgets.dart';

class Shots {
  final int redTeamShots, blueTeamShots;

  Shots({@required this.redTeamShots, @required this.blueTeamShots});
}

abstract class Matchmaking {
  static Shots shotsNumber(
    double redTeamStrength,
    double blueTeamStrength,
  ) {
    final double percentageDifference =
        ((blueTeamStrength - redTeamStrength) / redTeamStrength * 100);

    int redTeamShots;
    int blueTeamShots;

    if (percentageDifference < 0) {
      // Blue team is weaker
      if (percentageDifference <= -20) {
        redTeamShots = 3 + Random().nextInt(3);
        blueTeamShots = 2 + Random().nextInt(2);
      } else if (percentageDifference > -20 && percentageDifference <= -10) {
        redTeamShots = 3 + Random().nextInt(2);
        blueTeamShots = 3 + Random().nextInt(2);
      } else if (percentageDifference > -10) {
        redTeamShots = 2 + Random().nextInt(2);
        blueTeamShots = 3 + Random().nextInt(3);
      }
    } else if (percentageDifference > 0) {
      // Red team is weaker
      if (percentageDifference <= 10) {
        redTeamShots = 2 + Random().nextInt(2);
        blueTeamShots = 3 + Random().nextInt(3);
      } else if (percentageDifference > 10 && percentageDifference <= 20) {
        redTeamShots = 1 + Random().nextInt(3);
        blueTeamShots = 4 + Random().nextInt(4);
      } else if (percentageDifference > 20) {
        redTeamShots = 1 + Random().nextInt(2);
        blueTeamShots = 4 + Random().nextInt(6);
      }
    } else {
      // Equal stats
      redTeamShots = 2 + Random().nextInt(2);
      blueTeamShots = 3 + Random().nextInt(3);
    }

    return Shots(redTeamShots: redTeamShots, blueTeamShots: blueTeamShots);
  }
}
