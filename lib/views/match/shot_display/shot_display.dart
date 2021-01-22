import 'dart:async';

import 'package:flutter/material.dart';
import 'package:static_soccer/views/match/bloc/gameplay_controller.dart';
import 'package:static_soccer/views/match/bloc/score_controller.dart';
import 'package:static_soccer/views/match/bloc/timer_controller.dart';
import 'package:static_soccer/views/match/shot_display/button_row.dart';
import 'package:static_soccer/views/match/shot_display/player_name_display.dart';
import 'package:static_soccer/views/match/shot_display/timer.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  final List<VideoPlayerController> playerList;
  final VideoPlayerController shotController;
  final Function dispose;
  final bool requiresInput;

  VideoDisplay({
    @required this.playerList,
    @required this.shotController,
    @required this.dispose,
    @required this.requiresInput,
  });

  @override
  State<StatefulWidget> createState() {
    return _VideoDisplayState();
  }
}

class _VideoDisplayState extends State<VideoDisplay>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scale;

  VideoPlayerController _videoController;

  final DateTime _shotStart = DateTime.now();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));
    _scale = Tween<double>(begin: 0.1, end: 1).animate(_animationController);

    _videoController = widget.playerList.first;

    _animationController.forward();
  }

  Future<void> _setVideos(int i) async {
    // Set new controller according to the user choice
    setState(() => _videoController = widget.playerList[i]);
    // Play the video (note: await doesn't wait for the video to finish)
    await _videoController.play();
    // Wait until the video had stopped playing
    await Future.delayed(_videoController.value.duration, () async {
      // Continue with the random shot video
      setState(() => _videoController = widget.shotController);
      if (_videoController.dataSource.endsWith('Goal1.mp4') ||
          _videoController.dataSource.endsWith('Goal2.mp4'))
        ScoreController.hit(
          _videoController.dataSource.contains('Red') ? 'red' : 'blue',
        );
      await _videoController.play();
      await Future.delayed(
        _videoController.value.duration,
        () async {
          // Reverse the animation, then destroy widget
          await _animationController.reverse();
          GameplayController.change(false);
          TimerController.change(_shotStart);
        },
      );
    });
  }

  final StreamController _timerController = StreamController.broadcast();
  void _hideTimer() => _timerController.add(false);

  final StreamController _playerNameController = StreamController.broadcast();
  void _showPlayerName(String name) => _playerNameController.add(name);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: _animationController.value,
          child: Transform.scale(
            scale: _scale.value,
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size?.width ?? 0,
                  height: _videoController.value.size?.height ?? 0,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: StreamBuilder(
            stream: _timerController.stream,
            initialData: true,
            builder: (context, visible) => AnimatedOpacity(
              opacity: visible.data ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: DecisionTimer(
                hide: _hideTimer,
                shoot: _setVideos,
                visible: visible.data,
                short: !widget.requiresInput,
                playerNames: [
                  for (var controller in widget.playerList)
                    controller.dataSource.split('_').last.split('.').first,
                ],
                showPlayerName: _showPlayerName,
              ),
            ),
          ),
        ),
        Center(
          child: StreamBuilder(
            stream: _playerNameController.stream,
            builder: (context, name) => name.hasData
                ? PlayerNameDisplay(name: name.data)
                : const SizedBox(),
          ),
        ),
        if (widget.requiresInput)
          Positioned(
            bottom: MediaQuery.of(context).size.height / 10,
            left: 16,
            right: 16,
            child: ButtonRow(
              setVideo: _setVideos,
              names: [
                for (var controller in widget.playerList)
                  controller.dataSource.split('_').last.split('.').first,
              ],
              hideTimer: _hideTimer,
              showPlayerName: _showPlayerName,
              nameStream: _playerNameController.stream,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerController.close();
    _playerNameController.close();
    widget.dispose();
    super.dispose();
  }
}
