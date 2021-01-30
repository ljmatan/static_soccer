import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';

class NameAndStrength extends StatelessWidget {
  final bool left;

  NameAndStrength({@required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left ? 20 : 0,
      top: 0,
      right: left ? 0 : 20,
      bottom: 0,
      child: Align(
        alignment: left ? Alignment.centerLeft : Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                Prefs.instance
                    .getDouble((left ? 'Blue' : 'Red') + ' Team' + ' strength')
                    .toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              (left ? 'BLUE' : 'RED') + ' TEAM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: left ? Colors.blue.shade300 : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
