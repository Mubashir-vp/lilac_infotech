// ignore_for_file: unnecessary_null_comparison

import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lilac_info_tech/core/encrypt.dart';
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
  List<String> uniqueKeys = [
    'my 01 length key................',
    'my 02 length key................',
    'my 03 length key................',
  ];
  VideoPlayerController? _videoPlayerController;
  final progressNotifier = ValueNotifier<double?>(0);
  _getNormalFile(Directory directory, fileName) async {
    try {
      Uint8List? encData = await _readData('$fileName.aes');
      var plainData = await _decryptData(encData);
      String p = await _writeData(plainData, fileName);
      dev.log('File decrypted successfully : $p');
      return p;
    } catch (e) {
      dev.log('Error Occured in _getNormalFile$e');
    }
  }

  _writeData(dataTowrite, fileNameWithPath) async {
    dev.log('writing data...');
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataTowrite);
    return f.absolute.toString();
  }

  Future<Uint8List?> _readData(fileNameWithPath) async {
    try {
      dev.log('Reading data... $fileNameWithPath');
      File f = File(fileNameWithPath);
      return await f.readAsBytes();
    } catch (e) {
      dev.log('Error Occured in _readData $e');
      return null;
    }
  }

  _decryptData(encData) {
    try {
      dev.log('File decryption in progress');
      enc.Encrypted en = enc.Encrypted(encData);
      return MyEncrypt.myEncrypter.decryptBytes(en, iv: MyEncrypt.myIv);
    } catch (e) {
      dev.log('Error occured in _decryptData $e');
    }
  }

  newEncryptFile(
    filepath,
  ) async {
    try {
      final encrypted =
          MyEncrypt.myEncrypter.encryptBytes(filepath, iv: MyEncrypt.myIv);
      return encrypted.bytes;
    } catch (e) {
      dev.log('Error in encryption$e');
    }
  }

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
      var dir = await getExternalVisibleDir;
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
         
        } else if(isEncryptedExist){
           dev.log(
            'VideoFrom encrypted file $file',
          );
        await  _getNormalFile(dir, filePath);
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
        }
        else {
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

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/MyEncFolder').exists()) {
      final dir = Directory('/storage/emulated/0/MyEncFolder');
      return dir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder')
          .create(recursive: true);
      final dir = Directory('/storage/emulated/0/MyEncFolder');
      return dir;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text(_isSecureMode ? 'Secure Mode' : 'UnSecure Mode'),
          onPressed: () {
            _isSecureMode = !_isSecureMode;
            dev.log("SecureMode checking $_isSecureMode");
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
                              dev.log('SelectedIndex $selectedIndex, ');
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
                                  var dir = await getExternalVisibleDir;
                                  if (dir != null) {
                                    List<String> list = url[selectedIndex].split(
                                        'https://my-bucket-to.s3.amazonaws.com/');
                                    if (list.isNotEmpty && list != null) {
                                      String savename = list[1];
                                      try {
                                        final res = await http.get(
                                          Uri.parse(url[selectedIndex]),
                                          //     onReceiveProgress:
                                          //         (received, total) {
                                          //   if (total != -1) {
                                          //     _isDownloading = true;
                                          //     setState(() {});
                                          //     progressNotifier.value =
                                          //         (received / total * 100);
                                          //   }
                                          // }
                                        );
                                        final encResult = await newEncryptFile(
                                          res.bodyBytes,
                                        );
                                        String p = await _writeData(encResult,
                                            '${dir.path}/$savename.aes');
                                        dev.log('Encryption success : $p');
                                        // dev.log(encryptedFilePath.toString());

                                        // final File file = File(savePath);
                                        // await file.writeAsBytes(response.data,
                                        //     flush: true);
                                        // await encryptVideoFile(file.path);
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
                                      } on DioError catch (e) {
                                        dev.log(e.message);
                                      }
                                    }
                                  }
                                } else if (await Permission.storage
                                    .request()
                                    .isPermanentlyDenied) {
                                  dev.log('Not Permenently authenticated');
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
