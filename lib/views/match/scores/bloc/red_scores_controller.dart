import 'dart:async';

import 'package:static_soccer/views/match/scores/bloc/score_model.dart';

abstract class RedScoresController {
  static List<Score> _scores;
  static List<Score> get scores => _scores;

  static StreamController _streamController;

  static void init() {
    _streamController = StreamController.broadcast();
    _scores = [];
  }

  static Stream get stream => _streamController.stream;

  static void add(value) {
    _scores.add(value);
    _streamController.add(_scores);
  }

  static void dispose() {
    _streamController.close();
    _scores = null;
  }
}