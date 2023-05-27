import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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
  late VideoPlayerController _videoPlayerController;
  List<String> url = [
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.09+PM+(1).mp4',
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.08+PM.mp4',
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.09+PM.mp4'
  ];
  int selectedIndex = 0;
  String fileurl =
      'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+4.21.52+PM.mp4';
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(url[selectedIndex],
        formatHint: VideoFormat.other)
      ..addListener(() {
        setState(
          () {},
        );
      })
      ..setLooping(true)
      ..initialize().then(
        (value) => _videoPlayerController.play(),
      );
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VideoPlayerWidget(
              videoController: _videoPlayerController,
            ),
            Padding(
              padding: const EdgeInsets.all(
                20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      log('SelectedIndex $selectedIndex, ');
                      if (selectedIndex != 0) {
                        selectedIndex--;
                      } else {
                        selectedIndex = 1;
                      }
                      setState(() {});
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
                      if (await Permission.storage.request().isGranted) {
                        var dir =
                            await DownloadsPathProvider.downloadsDirectory;
                        if (dir != null) {
                          String savename = "file.pdf";
                          String savePath = "${dir.path}/$savename";
                          log(savePath);
                          //output:  /storage/emulated/0/Download/banner.png

                          try {
                            await Dio().download(fileurl, savePath,
                                onReceiveProgress: (received, total) {
                              if (total != -1) {
                                log("${(received / total * 100).toStringAsFixed(0)}%");
                                //you can build progressbar feature too
                              }
                            });
                            log("File is saved to download folder.");
                          } on DioError catch (e) {
                            log(e.message);
                          }
                        }
                      } else if (await Permission.storage
                          .request()
                          .isPermanentlyDenied) {
                        log('Not Permenently authenticated');
                        await openAppSettings();
                      } else if (await Permission.storage.request().isDenied) {
                        log('Not authenticated');
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
                              Icons.arrow_drop_down_outlined,
                              color: HexColor(
                                '#57EE9D',
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Download',
                              style: GoogleFonts.poppins(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      log('SelectedIndex $selectedIndex, ');
                      if (selectedIndex != 2) {
                        selectedIndex++;
                      } else {
                        selectedIndex = 0;
                      }
                      setState(() {});
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
            )
          ],
        ),
      ),
    );
  }
}
