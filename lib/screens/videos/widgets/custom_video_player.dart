import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoFilePath;
  const CustomVideoPlayer({Key? key, required this.videoFilePath})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    final canvas = MediaQuery.of(context).size;
    return SizedBox(
      height: canvas.height * 0.25,
      width: double.infinity,
      child: BetterPlayer.file(
        widget.videoFilePath,
        betterPlayerConfiguration: const BetterPlayerConfiguration(
          placeholderOnTop: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
              // enableFullscreen: false,
              //enableSkips: false,
              ),
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
