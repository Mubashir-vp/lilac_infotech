import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicOverlay extends StatelessWidget {
  const BasicOverlay({super.key, required this.videoPlayerController});
  final VideoPlayerController videoPlayerController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(bottom: 0, right: 0, left: 0, child: buildIndicator())
      ],
    );
  }

  Widget buildIndicator() => VideoProgressIndicator(
        videoPlayerController,
        allowScrubbing: true,
      );
}
