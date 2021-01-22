import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';
import 'package:static_soccer/views/home/top_bar/edit_strength.dart';

class StrengthDisplay extends StatefulWidget {
  final String label;
  final double initial;
  final Color color;

  StrengthDisplay({
    @required this.label,
    @required this.initial,
    @required this.color,
  });

  @override
  State<StatefulWidget> createState() {
    return _StrengthDisplayState();
  }
}

class _StrengthDisplayState extends State<StrengthDisplay> {
  @override
  void initState() {
    super.initState();
    if (Prefs.instance.getDouble(widget.label + ' strength') == null)
      Prefs.instance.setDouble(widget.label + ' strength', widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.label),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        Prefs.instance
                                .getDouble(widget.label + ' strength')
                                ?.toStringAsFixed(1) ??
                            widget.initial.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Text('Strength'),
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        final rebuild = await showDialog(
          context: context,
          builder: (context) => EditStrengthDialog(team: widget.label),
        );
        if (rebuild != null && rebuild) setState(() {});
      },
    );
  }
}
