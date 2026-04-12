import 'package:chewie/chewie.dart';
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
  ChewieController? chewieController;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL))
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: true,
          allowFullScreen: true,
          allowMuting: true,
        );
        setState(() {});
      });
    _controller.addListener(() {
      if (_controller.value.hasError) {
        debugPrint("Video Error: ${_controller.value.errorDescription}");
        debugPrint("video URL::: ${widget.videoURL}");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("video url::::::: ${widget.videoURL}");
    return widget.videoURL.isEmpty
        ? Center(child: Text("No video URL found of this post"))
        : chewieController != null &&
              chewieController!.videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio:
                chewieController!.videoPlayerController.value.aspectRatio,
            child: Chewie(controller: chewieController!),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
