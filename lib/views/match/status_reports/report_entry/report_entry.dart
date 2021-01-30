import 'package:flutter/material.dart';

class ReportEntry extends StatelessWidget {
  final String type, team;
  final int minutes, index;

  ReportEntry({
    @required this.type,
    @required this.team,
    @required this.minutes,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: index == 0 ? 1 : 0.8,
      child: Opacity(
        opacity: index == 0 ? 1 : 0.7,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/ui/notification.png',
                    height: 96,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    '$type kick for $team Team',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0270be),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              fit: StackFit.passthrough,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffE1ECFF),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Image.asset(
                        'assets/ui/${team}_progress.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/ui/minute_chip.png', width: 80),
                      Text(
                        minutes.toString() + '\'',
                        style: const TextStyle(
                          color: Color(0xff0370BE),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
