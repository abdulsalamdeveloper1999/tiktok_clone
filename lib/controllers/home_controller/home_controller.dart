import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/utils/global_var.dart';

class HomeController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);

  List<VideoModel> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(firebaseFirestore
        .collection('videos')
        .snapshots()
        .map((QuerySnapshot query) {
      List<VideoModel> retVal = [];
      for (var element in query.docs) {
        // Check if data is not null before casting
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;

        if (data != null) {
          retVal.add(VideoModel.fromMap(data));
        }
      }
      return retVal;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc =
        await firebaseFirestore.collection('videos').doc(id).get();

    var uid = authController.user.uid;

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firebaseFirestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
