import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';

class NameAndStrength extends StatefulWidget {
  final bool left;

  NameAndStrength({@required this.left});

  @override
  State<StatefulWidget> createState() {
    return _NameAndStrengthState();
  }
}

class _NameAndStrengthState extends State<NameAndStrength> {
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      Padding(
        padding: EdgeInsets.only(
          left: widget.left ? 0 : 8,
          right: widget.left ? 8 : 0,
        ),
        child: Text(
          Prefs.instance
              .getDouble((widget.left ? 'Blue' : 'Red') + ' Team' + ' strength')
              .toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Text(
        (widget.left ? 'BLUE' : 'RED') + ' TEAM',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.left ? Colors.blue.shade300 : Colors.red,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left ? 20 : 0,
      top: 0,
      right: widget.left ? 0 : 20,
      bottom: 0,
      child: Align(
        alignment: widget.left ? Alignment.centerLeft : Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.left ? _children : _children.reversed.toList(),
        ),
      ),
    );
  }
}
