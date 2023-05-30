import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lilac_info_tech/widgets/basicoverlay.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoPlayerController,
    required this.onPressed2,
    required this.onPressed1,
  });
  final VideoPlayerController videoPlayerController;
  final onPressed1;
  final onPressed2;

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController.value.isInitialized) {
      return Container(
        alignment: Alignment.topCenter,
        child: buildVideo(),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CircularProgressIndicator(color: HexColor('#57EE9D')),
        ),
      );
    }
  }

  Widget buildVideo() => Stack(
        children: [
          buildVideoPlayerWidget(),
          Positioned.fill(
            child: BasicOverlay(
              videoPlayerController: videoPlayerController,
              onPressed1: onPressed1,
              onPressed2: onPressed2,
            ),
          ),
        ],
      );

  Widget buildVideoPlayerWidget() => AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: VideoPlayer(
          videoPlayerController,
        ),
      );
}
