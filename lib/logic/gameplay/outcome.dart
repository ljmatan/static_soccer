import 'dart:async' show StreamController;
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:static_soccer/global/values.dart' as global;
import 'package:static_soccer/views/match/bloc/gameplay_controller.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';
import 'package:static_soccer/views/match/bloc/timer_controller.dart';
import 'package:static_soccer/views/match/scores/bloc/blue_scores_controller.dart';
import 'package:static_soccer/views/match/scores/bloc/red_scores_controller.dart';
import 'package:static_soccer/views/match/scores/bloc/score_model.dart';
import 'package:video_player/video_player.dart' show VideoPlayerController;

abstract class Outcome {
  /// Player list determined randomly according to the current game mode.
  static void setPlayers(Set playerList, String mode) {
    while (playerList.length < 3)
      switch (mode) {
        case 'Corner':
          playerList
              .add(global.Values.cornerPlayers.elementAt(Random().nextInt(4)));
          break;
        case 'Cross':
          playerList
              .add(global.Values.crossPlayers.elementAt(Random().nextInt(4)));
          break;
        case 'Freekick':
          playerList.add(
              global.Values.freeKickPlayers.elementAt(Random().nextInt(4)));
          break;
        case 'Pass':
          playerList
              .add(global.Values.passPlayers.elementAt(Random().nextInt(4)));
          break;
        case 'Penalty':
          playerList
              .add(global.Values.penaltyPlayers.elementAt(Random().nextInt(4)));
          break;
        case 'Shoot':
          playerList
              .add(global.Values.shootPlayers.elementAt(Random().nextInt(4)));
          break;
      }
  }

  // Video list determined randomly
  static Future<void> setVideos(
    StreamController viewController,
    VideoPlayerController playerController,
    VideoPlayerController shotController,
    AnimationController displayController,
    int timeInMinutes,
  ) async {
    // Set video controller according to the player choice
    viewController.add(playerController);

    // Play the video (note: await doesn't wait for the video to finish)
    await playerController.play();

    // Wait until the video had stopped playing
    await Future.delayed(playerController.value.duration, () async {
      // Continue with the random shot video
      viewController.add(shotController);

      // If the filename of the video being played ends with below values, update the score.
      if (shotController.dataSource.endsWith('Goal1.mp4') ||
          shotController.dataSource.endsWith('Goal2.mp4')) {
        final bool blueTeam = shotController.dataSource.contains('Blue');

        ScoreController.hit(blueTeam ? 'blue' : 'red');

        final String playerName =
            playerController.dataSource.split('_').last.split('.').first;
        final Score score = Score(timeInMinutes, playerName);
        blueTeam
            ? BlueScoresController.add(score)
            : RedScoresController.add(score);
      }

      await shotController.play();
      await Future.delayed(
        shotController.value.duration,
        () async {
          // Reverse the animation, then destroy widget
          await displayController.reverse();
          GameplayController.change(false);
          // Start running timer again
          TimerController.change(0);
          // Dispose of controllers. Placing this code into the widget dispose function
          // results in an exception.
          playerController.dispose();
          shotController.dispose();
        },
      );
    });
  }

  // Controllers set according to the player videos
  static Future<void> setControllers(
    BuildContext context,
    int i,
    String mode,
    String color,
    Set players,
    StreamController viewController,
    VideoPlayerController playerController,
    VideoPlayerController shotController,
    AnimationController displayController,
    int timeInMinutes,
  ) async {
    String playerVideo, shotVideo;

    // Assign video values
    playerVideo =
        'assets/$mode/1_SelectPlayer/${color}_${players.elementAt(i)}.mp4';

    // Set below variable according to the following rules:
    // - If number <= 3 play Goal1 video
    // - If number > 3 and <= 6 play Goal2 video
    // - If number > 6 and <= 8 play Hold video
    // - If number > 8 (max 10) play Miss video
    // This would mean that the player has 30% + 30% chance of scoring
    final int random = Random().nextInt(11);
    final int shotIndex = random <= 3
        ? 0
        : random > 3 && random <= 6
            ? 1
            : random > 6 && random <= 8
                ? 2
                : 3;
    shotVideo =
        'assets/$mode/2_Result/${color}_${global.Values.shots.elementAt(shotIndex)}.mp4';

    // Initialize videos and their respective controllers
    try {
      playerController = VideoPlayerController.asset(playerVideo);
      shotController = VideoPlayerController.asset(shotVideo);

      await playerController.initialize();
      await shotController.initialize();
    } catch (e) {
      // On error such as https://github.com/flutter/flutter/issues/72643 display a snackbar
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    Outcome.setVideos(
      viewController,
      playerController,
      shotController,
      displayController,
      timeInMinutes,
    );
  }
}
