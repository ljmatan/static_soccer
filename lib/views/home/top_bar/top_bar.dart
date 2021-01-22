import 'package:flutter/material.dart';
import 'package:static_soccer/views/home/top_bar/strength_display.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StrengthDisplay(
          label: 'Red Team',
          initial: 40.5,
          color: Colors.red.shade300,
        ),
        StrengthDisplay(
          label: 'Blue Team',
          initial: 38.3,
          color: Colors.blue.shade300,
        ),
      ],
    );
  }
}
