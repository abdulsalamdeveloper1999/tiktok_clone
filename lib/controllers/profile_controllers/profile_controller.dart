import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/utils/global_var.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = ''.obs;

  updateProfile(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnail = [];

    var myVideos = await firebaseFirestore
        .collection('videos')
        .where("uid", isEqualTo: _uid.value)
        .get();

    for (var i = 0; i < myVideos.docs.length; i++) {
      thumbnail.add(
        (myVideos.docs[i].data() as dynamic)["thumbnail"],
      );
    }

    DocumentSnapshot userDocument =
        await firebaseFirestore.collection('users').doc(_uid.value).get();

    final userData = (userDocument.data()! as dynamic);

    String name = userData['name'];
    String profilePhoto = userData['profilePic'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var items in myVideos.docs) {
      likes += (items.data()['likes'] as List).length;
    }

    var followerDoc = await firebaseFirestore
        .collection("users")
        .doc(_uid.value)
        .collection("followers")
        .get();

    var followingDoc = await firebaseFirestore
        .collection("users")
        .doc(_uid.value)
        .collection("following")
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection("followers")
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      "followers": followers.toString(),
      "following": following.toString(),
      "isFollowing": isFollowing,
      "likes": likes.toString(),
      "profilePic": profilePhoto,
      "name": name,
      "thumbnails": thumbnail,
    };

    update();
  }

  void followUser() async {
    var doc = await firebaseFirestore
        .collection("users")
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      await firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});

      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});

      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
      update();
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();

      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();

      _user.value
          .update('followers', (value) => (int.parse(value) - 1).toString());

      _user.value.update('isFollowing', (value) => !value);
      update();
    }
  }
}
