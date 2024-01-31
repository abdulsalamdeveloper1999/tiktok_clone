import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_compress/video_compress.dart';
import 'package:tiktok_clone/models/video_model.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.Res640x480Quality,
        deleteOrigin: false,
        includeAudio: true,
        frameRate: 24);
    // log('video got compressed ');
    return compressedVideo!.file;
  }

  getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> uploadVideo(String id, String videoPath) async {
    Reference ref = _firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await compressVideo(videoPath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    // log('video uploaded and download url is $downloadUrl');
    return downloadUrl;
  }

  Future<String> uploadImage(String id, String videoPath) async {
    Reference ref = _firebaseStorage.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await getThumbnail(videoPath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addVideoToDatabase({
    required String uid,
    // required String songName,
    required String songCaption,
    required String id,
    required String videoUrl,
    required String thumbnail,
  }) async {
    try {
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();

      VideoModel videoModel = VideoModel(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: id,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        // songName: songName,
        songCaption: songCaption,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
      );

      await _firebaseFirestore
          .collection('videos')
          .doc(id)
          .set(videoModel.toMap());
    } catch (e, stackTrace) {
      log('Error while adding video to database: $e',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
