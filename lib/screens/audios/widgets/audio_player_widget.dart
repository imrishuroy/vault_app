import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String path;
  const AudioPlayerWidget({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final player = AudioPlayer();

  bool _isPlaying = false;

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: 40.0,
      child: IconButton(
        onPressed: () async {
          if (_isPlaying) {
            await player.pause();
            setState(() {
              _isPlaying = false;
            });
          } else {
            setState(() {
              _isPlaying = true;
            });
            await player.play(DeviceFileSource(widget.path));
          }
        },
        icon: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }
}
