import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';
import 'package:static_soccer/logic/matchmaking/matchmaking.dart';
import 'package:static_soccer/views/match/match_screen.dart';

class StartMatchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.green.shade300,
        ),
        child: SizedBox(
          height: 48,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: const Text(
              'START MATCH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      onTap: () async {
        await Prefs.instance
            .setString('matchStart', DateTime.now().toIso8601String());
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MatchScreen(
                  shots: Matchmaking.shotsNumber(
                    Prefs.instance.getDouble('Red Team strength'),
                    Prefs.instance.getDouble('Blue Team strength'),
                  ),
                )));
      },
    );
  }
}
