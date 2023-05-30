import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

class BasicOverlay extends StatefulWidget {
  const BasicOverlay({super.key, required this.videoPlayerController,required this.onPressed2,required this.onPressed1,});
  final VideoPlayerController videoPlayerController;
  final onPressed1;
  final onPressed2;

  @override
  State<BasicOverlay> createState() => _BasicOverlayState();
}

class _BasicOverlayState extends State<BasicOverlay> {
  bool _isMute = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 40,
          right: 0,
          left: 0,
          child: buildIndicator(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: buildControlls(),
        )
      ],
    );
  }

  Widget buildIndicator() => VideoProgressIndicator(
        widget.videoPlayerController,
        allowScrubbing: true,
        colors: VideoProgressColors(
          playedColor: HexColor(
            '#57EE9D',
          ),
        ),
      );

  buildControlls() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(FontAwesomeIcons.backwardStep, color: Colors.white, size: 15),
          // SizedBox(
          //   width: 10,
          // ),
          // Icon(FontAwesomeIcons.forwardStep, color: Colors.white, size: 15),
          // SizedBox(
          //   width: 15,
          // ),
          IconButton(
              icon: Icon(FontAwesomeIcons.backwardStep,
                  color: Colors.white, size: 14),
              onPressed: widget.onPressed1),
          IconButton(
              icon: Icon(FontAwesomeIcons.backward,
                  color: Colors.white, size: 14),
              onPressed: () {
                Duration currentPosition =
                    widget.videoPlayerController.value.position;
                Duration targetPosition =
                    currentPosition - const Duration(seconds: 2);
                widget.videoPlayerController.seekTo(targetPosition);
              }),
          IconButton(
              onPressed: () {
                setState(() {
                  if (widget.videoPlayerController.value.isPlaying) {
                    widget.videoPlayerController.pause();
                  } else {
                    widget.videoPlayerController.play();
                  }
                });
              },
              icon: Icon(
                  widget.videoPlayerController.value.isPlaying
                      ? FontAwesomeIcons.pause
                      : FontAwesomeIcons.play,
                  color: Colors.white,
                  size: 15)),
          IconButton(
              icon:
                  Icon(FontAwesomeIcons.forward, color: Colors.white, size: 14),
              onPressed: () {
                Duration currentPosition =
                    widget.videoPlayerController.value.position;
                Duration targetPosition =
                    currentPosition + const Duration(seconds: 2);
                widget.videoPlayerController.seekTo(targetPosition);
              }),

          IconButton(
              icon: Icon(FontAwesomeIcons.forwardStep,
                  color: Colors.white, size: 14),
              onPressed: widget.onPressed2),
          Spacer(),
          IconButton(
              icon: Icon(
                  _isMute
                      ? FontAwesomeIcons.volumeOff
                      : FontAwesomeIcons.volumeHigh,
                  color: Colors.white,
                  size: 14),
              onPressed: () {
                if (_isMute) {
                  widget.videoPlayerController.setVolume(1.0);
                  _isMute = !_isMute;
                } else {
                  widget.videoPlayerController.setVolume(0.0);
                  _isMute = !_isMute;
                }
                setState(() {});
              }),
        ],
      );
}
