// import 'dart:developer';

// import 'package:better_player/better_player.dart';
// import 'package:dio/dio.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Home extends StatefulWidget {
//   const Home({
//     super.key,
//   });
//   @override
//   State<Home> createState() => _HomeState();
// }

// List<String> url = [
//   'https://drive.google.com/uc?id=1G-siiLEXg3Q7lx9TItl66WhhjzZf3W8t&export=download',
//   'https://drive.google.com/uc?id=1yLhWticHFVAKIhxHvvqVLedVRJfh-WgN&export=download'
// ];
// int selectedIndex = 0;

// class _HomeState extends State<Home> {
//   // late VideoPlayerController _videoPlayerController;
//   @override
//   void initState() {
//     // _videoPlayerController = VideoPlayerController.network(
//     //     formatHint: VideoFormat.other)
//     //   ..addListener(() {
//     //     setState(
//     //       () {},
//     //     );
//     //   })
//     //   ..setLooping(true)
//     //   ..initialize().then(
//     //     (value) => _videoPlayerController.play(),
//     //   );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log('SelectedIndex in build ${url[1]}, ********************');

//     return Scaffold(
//       backgroundColor: HexColor(
//         '#F3F3F3',
//       ),
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: BetterPlayer.network(
//               url[selectedIndex],
//               betterPlayerConfiguration: const BetterPlayerConfiguration(
//                 aspectRatio: 16 / 9,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(
//               20.0,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     log('SelectedIndex $selectedIndex, ');

//                     selectedIndex == 0 ? selectedIndex = 1 : selectedIndex = 0;
//                     setState(() {});
//                   },
//                   child: Container(
//                     height: 43,
//                     width: 43,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                         12,
//                       ),
//                     ),
//                     child: const Center(
//                       child: Icon(
//                         Icons.keyboard_arrow_left_outlined,
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                     onTap: () async {
//                             Map<Permission, PermissionStatus> statuses = await [
//                                 Permission.storage, 
//                                 //add more permission to request here.
//                             ].request();

//                             if(statuses[Permission.storage]!.isGranted){ 
//                                 var dir = await DownloadsPathProvider.downloadsDirectory;
//                                 if(dir != null){
//                                       String savename = "file.pdf";
//                                       String savePath = "${dir.path}/$savename";
//                                       print(savePath);
//                                       //output:  /storage/emulated/0/Download/banner.png

//                                       try {
//                                           await Dio().download(
//                                               url[0], 
//                                               savePath,
//                                               onReceiveProgress: (received, total) {
//                                                   if (total != -1) {
//                                                       print((received / total * 100).toStringAsFixed(0) + "%");
//                                                       //you can build progressbar feature too
//                                                   }
//                                                 });
//                                            print("File is saved to download folder.");  
//                                      } on DioError catch (e) {
//                                        print(e.message);
//                                      }
//                                 }
//                             }else{
//                                print("No permission to read and write.");
//                             }

//                          },
//                   child: Container(
//                     height: 50,
//                     width: 140,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                         12,
//                       ),
//                     ),
//                     child: Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.arrow_drop_down_outlined,
//                             color: HexColor(
//                               '#57EE9D',
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             'Download',
//                             style: GoogleFonts.poppins(),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     log('SelectedIndex $selectedIndex, ');
//                     selectedIndex == 0 ? selectedIndex = 1 : selectedIndex = 0;
//                     setState(() {});
//                   },
//                   child: Container(
//                     height: 43,
//                     width: 43,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                         12,
//                       ),
//                     ),
//                     child: const Center(
//                       child: Icon(
//                         Icons.keyboard_arrow_right_outlined,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
