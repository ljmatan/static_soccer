import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/info_bar/timer/time_controller.dart';

class ContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: TimeController.stream,
      builder: (context, time) => AnimatedPositioned(
        curve: Curves.bounceIn,
        duration: const Duration(seconds: 1),
        bottom: time.hasData && time.data == 90 ? 16 : -100,
        left: 16,
        right: 16,
        child: GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColor,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 48,
              child: const Center(
                child: Text(
                  'CONTINUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
