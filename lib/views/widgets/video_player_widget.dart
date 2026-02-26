import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoURL;
  const VideoPlayerWidget({super.key, required this.videoURL});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL))
      ..initialize().then((_) {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Color.fromARGB(255, 15, 156, 221),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: .spaceAround,
          children: [
            //seek backward
            IconButton(
              onPressed: () async {
                Duration currentDuration = _controller.value.position;
                await _controller.seekTo(
                  currentDuration - Duration(seconds: 10),
                );
              },
              icon: Icon(Icons.replay_10),
            ),
            //play/pause
            IconButton(
              onPressed: () async {
                if (_controller.value.isPlaying) {
                  debugPrint("Playing? : ${_controller.value.isPlaying}");
                  await _controller.pause();
                  debugPrint("Playing? : ${_controller.value.isPlaying}");
                } else {
                  await _controller.play();
                }
              },
              icon: Icon(
                _controller.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_arrow_rounded,
              ),
            ),
            //seek forward
            IconButton(
              onPressed: () async {
                Duration currentDuration = _controller.value.position;
                await _controller.seekTo(
                  currentDuration + Duration(seconds: 10),
                );
              },
              icon: Icon(Icons.forward_10),
            ),
          ],
        ),
      ],
    );
  }
}
