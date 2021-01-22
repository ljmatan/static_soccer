import 'dart:async';

abstract class ScoreController {
  static Map _currentScore;

  static StreamController _streamController;

  static void init() {
    _currentScore = {'red': 0, 'blue': 0};
    _streamController = StreamController.broadcast();
  }

  static Stream get stream => _streamController.stream;

  static void hit(team) {
    _currentScore[team]++;
    _streamController.add(_currentScore);
  }

  static void lost() => _streamController.add({'red': 3, 'blue': 0});

  static void dispose() {
    _currentScore = null;
    _streamController.close();
  }
}
