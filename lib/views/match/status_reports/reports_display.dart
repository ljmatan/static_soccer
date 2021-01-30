import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/status_reports/bloc/reports_controller.dart';
import 'package:static_soccer/views/match/status_reports/report_entry/report_entry.dart';

class StatusReports extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatusReportsState();
  }
}

class _StatusReportsState extends State<StatusReports> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ReportsController.stream,
      initialData: [],
      builder: (context, reports) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (int i = 0; i < reports.data.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReportEntry(
                type: reports.data.reversed.toList()[i].type,
                team: reports.data.reversed.toList()[i].team,
                minutes: reports.data.reversed.toList()[i].minutes,
                index: i,
              ),
            ),
        ],
      ),
    );
  }
}
