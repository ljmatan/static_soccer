import 'dart:async';

abstract class DecisionTimerController {
  static StreamController _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void display(bool value) => _streamController.add(value);

  static void dispose() => _streamController.close();
}
