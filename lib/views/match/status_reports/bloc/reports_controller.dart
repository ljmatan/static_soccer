import 'dart:async';

import 'package:static_soccer/views/match/status_reports/bloc/report_model.dart';

abstract class ReportsController {
  static List<StatusReport> _list;

  static StreamController<List<StatusReport>> _streamController;

  static void init() {
    _streamController = StreamController.broadcast();
    _list = [];
  }

  static Stream<List<StatusReport>> get stream => _streamController.stream;

  static void add(value) {
    _list.add(value);
    _streamController.add(_list);
  }

  static void dispose() {
    _streamController.close();
    _list = null;
  }
}
