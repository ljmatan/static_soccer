/// In this file all of the game-specific values are set, including:
/// 1. Game modes
/// 2. Shots
/// 3. Player names
///
/// These values are used in order to determine the correct video file to be played.

abstract class Values {
  static final Set<String> modes = const {
    'Corner',
    'Cross',
    'Freekick',
    'Pass',
    'Penalty',
    'Shoot',
  };

  static final Set<String> shots = {
    'Goal1',
    'Goal2',
    'Hold',
    'Miss',
  };

  static final Set<String> cornerPlayers = const {
    'Cris',
    'Fabio',
    'Franz',
    'Leon',
    'TheWall',
  };

  static final Set<String> crossPlayers = const {
    'Cris',
    'Fabio',
    'Leon',
    'Luis',
    'Samurai',
  };

  static final Set<String> freeKickPlayers = {
    'Cris',
    'Crossham',
    'Diego',
    'Dinho',
    'Leon',
  };

  static final Set<String> passPlayers = {
    'Cris',
    'Crossham',
    'Diego',
    'Dinho',
    'Leon',
  };
  static final Set<String> penaltyPlayers = {
    'Cris',
    'Crossham',
    'Franz',
    'Leon',
    'Luis'
  };
  static final Set<String> shootPlayers = {
    'Cris',
    'Diego',
    'Dinho',
    'Leon',
    'TheWall',
  };
}
