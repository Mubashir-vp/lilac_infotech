// import 'dart:developer';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:googleapis/drive/v3.dart' as drive;

// class GoogleDriveServices {
//   // Authenticate with Google Drive API
//   Future<http.Client> authenticate() async {
//     try {
//       final credentialsJson =
//           await rootBundle.loadString('assets/credentials.json');
//       final credentials =
//           auth.ServiceAccountCredentials.fromJson(credentialsJson);
//       final scopes = ["https://www.googleapis.com/auth/drive.file"];
//       final client = await auth.clientViaServiceAccount(credentials, scopes);
//       return client;
//     } catch (e) {
//       log('Error in authenticate: $e');
//       rethrow;
//     }
//   }

//   Future<void> uploadVideo(http.Client client) async {
//     final driveApi = drive.DriveApi(client);

//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//       allowMultiple: false,
//     );

//     if (result != null && result.files.isNotEmpty) {
//       final pickedFile = result.files.first;
//       final file = drive.File();
//       file.name = pickedFile.name;
//       file.parents = ['1SWdCmsgnMWk57oqoB58ogz_HIZrGAS3Z'];
//       if (pickedFile.path != null) {
//         final fileBytes = File(pickedFile.path!).readAsBytesSync();
//         final media = drive.Media(
//           http.ByteStream(Stream.value(fileBytes)),
//           pickedFile.size,
//         );
//         await driveApi.files.create(file, uploadMedia: media);
//       } else {
//         log('Picked file path is null');
//       }
//     }
//   }

//   // Get list of uploaded videos from Google Drive
//   Future<List<drive.File>> getUploadedVideos(
//       http.Client client, parentFolderId) async {
//     final driveApi = drive.DriveApi(client);
//     final query = "'$parentFolderId' in parents";
//     final fileList = await driveApi.files.list(q: query);
//     log('Domex${fileList.files![0].webViewLink}');
//     return fileList.files ?? [];
//   }

// //Download video from Google Drive
//   Future<void> downloadVideo(
//       http.Client client, String fileId, String savePath) async {
//     final driveApi = drive.DriveApi(client);
//     final response = await driveApi.files.export(
//       fileId,
//       'video/mp4', // Specify the MIME type of the video file
//     );

//     final fileStream = response?.stream;
//     if (fileStream != null) {
//       final file = File(savePath);
//       await file.writeAsBytes(await http.ByteStream(fileStream).toBytes());
//     }
//   }

// // Retrieve video links from Google Drive
//   // Retrieve video links from Google Drive
//   Future<List<String>> getVideoLinks(http.Client client, parentFolderId) async {
//     try {
//       final driveApi = drive.DriveApi(client);
//       final query = "mimeType='video/mp4' and '$parentFolderId' in parents";

//       final response = await driveApi.files.list(q: query);
//       log('response ${response.files![0].fileExtension}');
//       final videoFiles = response.files;
//       final videoLinks = <String>[];

//       for (var file in videoFiles!) {
//         final exportLinks = file.exportLinks;
//         final videoLink = exportLinks?['video/mp4'];
//         log('videoLink ${videoLink}');

//         if (videoLink != null) {
//           videoLinks.add(videoLink);
//         }
//       }
//       log('Video links $videoLinks');
//       return videoLinks;
//     } catch (e) {
//       log("Error in getVideoLinks $e");
//       return [];
//     }
//   }
// }
