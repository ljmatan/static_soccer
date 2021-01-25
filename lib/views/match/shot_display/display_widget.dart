import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DisplayWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool displayed;

  DisplayWidget({@required this.controller, this.displayed});

  @override
  State<StatefulWidget> createState() {
    return _DisplayWidgetState();
  }
}

class _DisplayWidgetState extends State<DisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.displayed == null || widget.displayed
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: widget.controller.value.size?.width ?? 0,
                height: widget.controller.value.size?.height ?? 0,
                child: VideoPlayer(widget.controller),
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
