import 'package:flutter/material.dart';
import 'package:lilac_info_tech/widgets/basicoverlay.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key, required this.videoController});
  final VideoPlayerController videoController;
  @override
  Widget build(BuildContext context) {
    if (videoController.value.isInitialized) {
      return Container(
        alignment: Alignment.topCenter,
        child: buildVideo(),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );
    }
  }

  Widget buildVideo() => Stack(
        children: [
          buildVideoPlayerWidget(),
          Positioned.fill(
            child: BasicOverlay(
              videoPlayerController: videoController,
            ),
          ),
        ],
      );

  Widget buildVideoPlayerWidget() => AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: VideoPlayer(
          videoController,
        ),
      );
}
