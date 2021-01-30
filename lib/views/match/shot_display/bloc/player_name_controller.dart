import 'dart:async';

abstract class PlayerNameController {
  static StreamController _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void display(String name) => _streamController.add(name);

  static void dispose() => _streamController.close();
}
