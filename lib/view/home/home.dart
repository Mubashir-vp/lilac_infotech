// ignore_for_file: unnecessary_null_comparison

import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lilac_info_tech/view/login/login.dart';
import 'package:lilac_info_tech/view/settings/settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../core/bloc/auth_bloc/auth_bloc.dart';
import '../../core/data/model/userModel.dart';
import '../../core/data/services/video.services.dart';
import '../../widgets/videoplayer.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.userModel,
  });
  final UserModel userModel;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController? _videoPlayerController;
  final progressNotifier = ValueNotifier<double?>(0);

  List<String> url = [
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.09+PM+(1).mp4',
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.08+PM.mp4',
    'https://my-bucket-to.s3.amazonaws.com/WhatsApp+Video+2023-05-27+at+8.08.09+PM.mp4'
  ];
  int selectedIndex = 0;
  bool _isInitialized = false;
  bool _isSavedVideo = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  initPlayer() async {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
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
          if (await Permission.storage.request().isGranted &&
              await Permission.manageExternalStorage.request().isGranted) {
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
          } else if (await Permission.storage.request().isPermanentlyDenied &&
              await Permission.manageExternalStorage
                  .request()
                  .isPermanentlyDenied) {
            dev.log('Permenently denied');
            await openAppSettings();
          } else if (await Permission.storage.request().isDenied &&
              await Permission.manageExternalStorage.request().isDenied) {
            dev.log('Not authenticated');
          }
        } else if (isEncryptedExist) {
          if (await Permission.storage.request().isGranted &&
              await Permission.manageExternalStorage.request().isGranted) {
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
          } else if (await Permission.storage.request().isPermanentlyDenied &&
              await Permission.manageExternalStorage
                  .request()
                  .isPermanentlyDenied) {
            dev.log('Permenently denied');
            await openAppSettings();
          } else if (await Permission.storage.request().isDenied &&
              await Permission.manageExternalStorage.request().isDenied) {
            dev.log('Not authenticated');
          }
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
    if (_isInitialized) {
      _videoPlayerController!.dispose();
    }

    super.dispose();
  }

  final AuthBloc _authBloc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is LogedOutState) {
          log('LogedInState');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      },
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.userModel.imageLink),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userModel.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              widget.userModel.email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              widget.userModel.phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const SettingsScreen())),
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                ),
                ListTile(
                  onTap: () async {
                    _authBloc.add(const LogOut());
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                ),
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Builder(builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                  // _authBloc.add(const LogOut());
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FaIcon(FontAwesomeIcons.barsStaggered),
                ),
              );
            }),
            actions: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.userModel.imageLink,
                    ),
                  )

                  //  Container(
                  //   height: 43,
                  //   width: 43,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(
                  //       20,
                  //     ),
                  //   ),
                  //   child:
                  //    Image.network(
                  //     widget.userModel.imageLink,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  )
            ],
            backgroundColor: Colors.transparent,
          ),
          body: _isInitialized
              ? BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is VideoDownloaded) {
                      _isSavedVideo = true;
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: "File saved to downloads",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: HexColor('#57EE9D'),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (state is FailedState) {
                      dev.log('Video downloading failed ${state.errorString}');

                      Fluttertoast.showToast(
                          msg: state.errorString,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: HexColor('#57EE9D'),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      dev.log('Else $state');
                    }
                  },
                  bloc: homeBloc,
                  builder: (context, homeState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 262,
                            alignment: Alignment.topCenter,
                            child: VideoPlayerWidget(
                              videoPlayerController: _videoPlayerController!,
                              onPressed1: () async {
                                if (selectedIndex != 0) {
                                  selectedIndex--;
                                } else {
                                  selectedIndex = 2;
                                }
                                setState(() {});
                                await _videoPlayerController!.dispose();
                                await initPlayer();
                              },
                              onPressed2: () async {
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
                            ),
                          ),
                          _isInitialized
                              ? Padding(
                                  padding: const EdgeInsets.all(
                                    20.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (selectedIndex != 0) {
                                            selectedIndex--;
                                          } else {
                                            selectedIndex = 2;
                                          }
                                          setState(() {});
                                          await _videoPlayerController!
                                              .dispose();
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
                                              Icons
                                                  .keyboard_arrow_left_outlined,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          dev.log('Loging on TOP $homeState');
                                          if (!_isSavedVideo) {
                                            if (await Permission.storage
                                                .request()
                                                .isGranted) {
                                              var dir = await VideoServices()
                                                  .getExternalVisibleDir;
                                              if (dir != null) {
                                                List<String> list =
                                                    url[selectedIndex].split(
                                                        'https://my-bucket-to.s3.amazonaws.com/');
                                                if (list.isNotEmpty &&
                                                    list != null) {
                                                  String savename = list[1];
                                                  homeBloc.add(
                                                    DownloadVideo(
                                                        uri: url[selectedIndex],
                                                        path:
                                                            '${dir.path}/$savename.aes'),
                                                  );
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
                                            child: homeState is HomeLoading
                                                ? const CircularProgressIndicator()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        _isSavedVideo
                                                            ? Icons.done
                                                            : Icons
                                                                .arrow_drop_down_outlined,
                                                        color: HexColor(
                                                          '#57EE9D',
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        _isSavedVideo
                                                            ? 'Saved'
                                                            : 'Download',
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          dev.log(
                                              'SelectedIndex $selectedIndex, ');
                                          if (selectedIndex != 2) {
                                            selectedIndex++;
                                          } else {
                                            selectedIndex = 0;
                                          }
                                          dev.log(
                                              'ChangedIndex $selectedIndex, ');
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
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          homeState is HomeLoading
                              ? const Text(
                                  'Your video is downloading and encrypting\nPlease wait',
                                )
                              : const SizedBox(),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
