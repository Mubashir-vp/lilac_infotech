// ignore_for_file: unnecessary_null_comparison

import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../core/data/services/video.services.dart';
import '../../widgets/videoplayer.dart';
import 'bloc/home_bloc.dart';

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
  bool _isSecureMode = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  initPlayer() async {
    try {
      var dir = await VideoServices().getExternalVisibleDir;
      List<String> list =
          url[selectedIndex].split('https://my-bucket-to.s3.amazonaws.com/');
      if (list.isNotEmpty && list != null) {
        String savename = list[1];
        final filePath = "${dir.path}/$savename";
        final encryptedFile = File('$filePath.aes');
        final file = File(filePath);
        bool isExist = await file.exists();
        bool isEncryptedExist = await encryptedFile.exists();
        if (isExist) {
          dev.log(
            'VideoFrom non encrypted file $file',
          );
          _videoPlayerController = VideoPlayerController.file(
            file,
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
        } else if (isEncryptedExist) {
          dev.log(
            'VideoFrom encrypted file $file',
          );
          await VideoServices().getNormalFile(dir, filePath);
          _videoPlayerController = VideoPlayerController.file(
            file,
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
          dev.log('VideoFrom network ${url[selectedIndex]}');
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
      dev.log('Error caught $e');
    }
  }

  HomeBloc homeBloc = HomeBloc();
  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text(_isSecureMode ? 'Secure Mode' : 'UnSecure Mode'),
          onPressed: () {
            _isSecureMode = !_isSecureMode;
            setState(() {});
            if (_isSecureMode) {
              FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
            } else {
              FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
            }
          },
          icon: Icon(
            _isSecureMode
                ? FontAwesomeIcons.userSecret
                : FontAwesomeIcons.lockOpen,
          ),
        ),
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
            ? BlocBuilder<HomeBloc, HomeState>(
                bloc: homeBloc,
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
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
                                  if (selectedIndex != 0) {
                                    selectedIndex--;
                                  } else {
                                    selectedIndex = 2;
                                  }
                                  setState(() {});
                                  await _videoPlayerController!.dispose();
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
                                      var dir = await VideoServices()
                                          .getExternalVisibleDir;
                                      if (dir != null) {
                                        List<String> list = url[selectedIndex]
                                            .split(
                                                'https://my-bucket-to.s3.amazonaws.com/');
                                        if (list.isNotEmpty && list != null) {
                                          String savename = list[1];
                                          homeBloc.add(
                                            DownloadVideo(
                                              uri: url[selectedIndex],
                                            ),
                                          );

                                          if (state is VideoDownloaded) {
                                            final encResult =
                                                await VideoServices()
                                                    .newEncryptFile(
                                              state.response.bodyBytes,
                                            );
                                            await VideoServices().writeData(
                                                encResult,
                                                '${dir.path}/$savename.aes');
                                            _isDownloading = false;
                                            _isSavedVideo = true;
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
                                          } else if (state is FailedState) {
                                            Fluttertoast.showToast(
                                                msg: state.errorString,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    HexColor('#57EE9D'),
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }
                                      }
                                    } else if (await Permission.storage
                                        .request()
                                        .isPermanentlyDenied) {
                                      dev.log('Permenently denied');
                                      await openAppSettings();
                                    } else if (await Permission.storage
                                        .request()
                                        .isDenied) {
                                      dev.log('Not authenticated');
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  dev.log('SelectedIndex $selectedIndex, ');
                                  if (selectedIndex != 2) {
                                    selectedIndex++;
                                  } else {
                                    selectedIndex = 0;
                                  }
                                  dev.log('ChangedIndex $selectedIndex, ');
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
                                  dev.log('Progres checking $percent');
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
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
