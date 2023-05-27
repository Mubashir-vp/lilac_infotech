import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lilac_info_tech/widgets/basicoverlay.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoPlayerController,
  });
  final VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController.value.isInitialized) {
      return Container(
        alignment: Alignment.topCenter,
        child: buildVideo(
        ),
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
