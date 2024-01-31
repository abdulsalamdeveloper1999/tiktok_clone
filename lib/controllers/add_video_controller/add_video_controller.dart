import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tiktok_clone/services/database_services.dart';
import 'package:tiktok_clone/utils/global_var.dart';
import 'package:tiktok_clone/views/add_video_views/confirm_view.dart';

import 'package:video_player/video_player.dart';

class AddVideoController extends GetxController {
  //variables
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  bool _isImagePickerActive = false;
  late VideoPlayerController videoPlayerController;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    songController.dispose();
    captionController.dispose();
  }

  Future<void> pickVideo(ImageSource src, BuildContext context) async {
    if (_isImagePickerActive) {
      // If image picker is already active, do nothing
      return;
    }

    _isImagePickerActive = true;

    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Picking Video'),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final video = await ImagePicker().pickVideo(
        source: src,
      );

      Get.until((route) => route.isFirst); // Close all dialogs and screens

      if (video != null) {
        Get.to(
          () => ConfirmView(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        );
      } else {
        Get.snackbar('Error', 'You didn\'t pick any video');
      }
    } catch (e) {
      log('already active video picker');
      // Handle the error if needed
      Get.snackbar('Error', 'An error occurred while picking the video');
    } finally {
      _isImagePickerActive = false;
    }
  }

  // _compressVideo(String videoPath) async {
  //   final compressedVideo = await VideoCompress.compressVideo(
  //     videoPath,
  //     quality: VideoQuality.MediumQuality,
  //   );
  //   log('video got compressed ');
  //   return compressedVideo!.file;
  // }

  // _getThumbnail(String videoPath) async {
  //   final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
  //   return thumbnail;
  // }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    return await _databaseService.uploadVideo(id, videoPath);
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    return await _databaseService.uploadImage(id, videoPath);
  }

  // Future<String> _uploadVideoToStorage(String id, String videoPath) async {
  //   Reference ref = firebaseStorage.ref().child('videos').child(id);

  //   UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

  //   TaskSnapshot snap = await uploadTask;
  //   String downloadUrl = await snap.ref.getDownloadURL();
  //   log('video uploaded and download url is $downloadUrl');
  //   return downloadUrl;
  // }

  // Future<String> _uploadImageToStorage(String id, String videoPath) async {
  //   Reference ref = firebaseStorage.ref().child('thumbnails').child(id);

  //   UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));

  //   TaskSnapshot snap = await uploadTask;

  //   String downloadUrl = await snap.ref.getDownloadURL();

  //   return downloadUrl;
  // }

  uploadVideo(
    // String songName,
    String songCaption,
    String videoPath,
  ) async {
    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Uploading Video'),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
      var allDocs = await firebaseFirestore.collection('videos').get();
      var len = allDocs.docs.length;
      //get id
      String uid = firebaseAuth.currentUser!.uid;

      final videoUrl = await _uploadVideoToStorage('Video $len', videoPath);

      final thumbnail = await _uploadImageToStorage('Videos $len', videoPath);

      await _databaseService.addVideoToDatabase(
        uid: uid,
        // songName: songName,
        songCaption: songCaption,
        id: 'Video $len',
        videoUrl: videoUrl,
        thumbnail: thumbnail,
      );

      Get.back();
      Get.back();
      Get.back();
    } catch (e, stackTrace) {
      log('Error details: $stackTrace');
      Get.back(result: false);
    }
  }

  // uploadVideo(String songName, String songCaption, String videoPath) async {
  //   try {
  //     Get.dialog(
  //       const Center(
  //         child: Card(
  //           child: Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: ListTile(
  //               leading: CircularProgressIndicator(),
  //               title: Text('Uploading Video'),
  //             ),
  //           ),
  //         ),
  //       ),
  //       barrierDismissible: false,
  //     );
  //     String uid = firebaseAuth.currentUser!.uid;

  //     DocumentSnapshot userDoc =
  //         await firebaseFirestore.collection('users').doc(uid).get();

  //     //get id
  //     var allDocs = await firebaseFirestore.collection('videos').get();
  //     var len = allDocs.docs.length;

  //     final videoUrl = await _uploadVideoToStorage('Video $len', videoPath);

  //     final thumbnail = await _uploadImageToStorage('Videos $len', videoPath);

  //     VideoModel videoModel = VideoModel(
  //       username: (userDoc.data()! as Map<String, dynamic>)['username'],
  //       uid: uid,
  //       id: 'Video $len',
  //       likes: [],
  //       commentCount: 0,
  //       shareCount: 0,
  //       songName: songName,
  //       songCaption: songCaption,
  //       videoUrl: videoUrl,
  //       thumbnail: thumbnail,
  //       profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
  //     );

  //     await firebaseFirestore
  //         .collection('videos')
  //         .doc('Video $len')
  //         .set(videoModel.toMap());

  //     Get.back();
  //     Get.back();
  //     Get.back();
  //   } catch (e, stackTrace) {
  //     // Handle errors and log them
  //     Get.snackbar('Error while uploading', '$e');
  //     log('Error while uploading: $e', error: e, stackTrace: stackTrace);
  //   }
  // }
}
