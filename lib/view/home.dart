// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../widgets/videoplayer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? _videoPlayerController;
  final progressNotifier = ValueNotifier<double?>(0);
  List<String> url = [
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.09+PM+(1).mp4',
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.08+PM.mp4',
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.09+PM.mp4'
  ];
  int selectedIndex = 0;
  bool _isInitialized = false;
  bool _isDownloading = false;
  bool _isSavedVideo = false;

  @override
  void initState() {
    initPlayer();
    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController!,

    //   // Prepare the video to be played and display the first frame
    //   autoInitialize: true,
    //   allowFullScreen: false,
    //   aspectRatio: 16 / 9,
    //   looping: true,
    //   autoPlay: false,
    //   showControlsOnInitialize: false,
    //   // Errors can occur for example when trying to play a video
    //   // from a non-existent URL
    //   errorBuilder: (context, errorMessage) {
    //     return Center(
    //       child: Text(
    //         errorMessage,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     );
    //   },
    // );
    super.initState();
  }

  initPlayer() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      List<String> list =
          url[selectedIndex].split('https://my-bucket-to.s3.amazonaws.com/');
      if (list.isNotEmpty && list != null) {
        String savename = list[1];
        final filePath = "${dir.path}/$savename";
        final file = File(filePath);
        bool isExist = await file.exists();
        if (isExist) {
          log('VideoFrom file $filePath');
          _videoPlayerController = VideoPlayerController.file(
            File(filePath),
          )
            ..addListener(() {
              setState(
                () {},
              );
            })
            ..setLooping(true)
            ..initialize().then(
              (value) => _videoPlayerController!.play(),
            );
          _isSavedVideo = true;
        } else {
          //  await file.deleteSync();
          log('VideoFrom network ${url[selectedIndex]}');
          _videoPlayerController = VideoPlayerController.network(
              url[selectedIndex],
              formatHint: VideoFormat.other)
            ..addListener(() {
              setState(
                () {},
              );
            })
            ..setLooping(true)
            ..initialize().then(
              (value) => _videoPlayerController!.play(),
            );
          _isSavedVideo = false;
        }
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      log('Error caught $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(20.0),
            child: FaIcon(FontAwesomeIcons.barsStaggered),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Image.asset(
                  'assets/images/Rectangle 5.png',
                ),
              ),
            )
          ],
          backgroundColor: Colors.transparent,
        ),
        body: _isInitialized
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    // Chewie(controller: chewieController),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 262,
                      alignment: Alignment.topCenter,
                      child: VideoPlayerWidget(
                        videoPlayerController: _videoPlayerController!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                        20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              log('SelectedIndex $selectedIndex, ');
                              if (selectedIndex != 0) {
                                selectedIndex--;
                              } else {
                                selectedIndex = 2;
                              }
                              setState(() {});
                              _videoPlayerController!.dispose();
                              await initPlayer();
                            },
                            child: Container(
                              height: 43,
                              width: 43,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!_isSavedVideo) {
                                if (await Permission.storage
                                    .request()
                                    .isGranted) {
                                  var dir =
                                      await getApplicationDocumentsDirectory();
                                  if (dir != null) {
                                    List<String> list = url[selectedIndex].split(
                                        'https://my-bucket-to.s3.amazonaws.com/');
                                    if (list.isNotEmpty && list != null) {
                                      String savename = list[1];
                                      String savePath = "${dir.path}/$savename";
                                      log(savePath);
                                      //output:  /storage/emulated/0/Download/banner.png
                                      try {
                                        await Dio().download(
                                            url[selectedIndex], savePath,
                                            onReceiveProgress:
                                                (received, total) {
                                          if (total != -1) {
                                            _isDownloading = true;
                                            setState(() {});
                                            progressNotifier.value =
                                                (received / total * 100);

                                            log("${(received / total * 100).toStringAsFixed(0)}%");
                                            //you can build progressbar feature too
                                          }
                                        });
                                        _isDownloading = false;
                                        setState(() {});
                                        Fluttertoast.showToast(
                                            msg: "File saved to downloads",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                HexColor('#57EE9D'),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } on DioError catch (e) {
                                        log(e.message);
                                      }
                                    }
                                  }
                                } else if (await Permission.storage
                                    .request()
                                    .isPermanentlyDenied) {
                                  log('Not Permenently authenticated');
                                  await openAppSettings();
                                } else if (await Permission.storage
                                    .request()
                                    .isDenied) {
                                  log('Not authenticated');
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isSavedVideo
                                          ? Icons.done
                                          : Icons.arrow_drop_down_outlined,
                                      color: HexColor(
                                        '#57EE9D',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _isSavedVideo ? 'Saved' : 'Download',
                                      style: GoogleFonts.poppins(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              log('SelectedIndex $selectedIndex, ');
                              if (selectedIndex != 2) {
                                selectedIndex++;
                              } else {
                                selectedIndex = 0;
                              }
                              log('ChangedIndex $selectedIndex, ');
                              setState(() {});
                              _videoPlayerController!.dispose();
                              await initPlayer();
                            },
                            child: Container(
                              height: 43,
                              width: 43,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isDownloading == true
                        ? ValueListenableBuilder<double?>(
                            valueListenable: progressNotifier,
                            builder: (context, percent, child) {
                              log('Progres checking $percent');
                              return CircularPercentIndicator(
                                radius: 30,
                                percent: percent! / 100,
                                center: Text(
                                  "${percent.toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                progressColor: HexColor('#57EE9D'),
                              );
                            })
                        : const SizedBox(),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
