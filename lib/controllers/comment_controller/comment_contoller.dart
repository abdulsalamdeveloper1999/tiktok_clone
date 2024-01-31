import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/utils/global_var.dart';

class CommentController extends GetxController {
  TextEditingController commentController = TextEditingController();

  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([]);
  List<CommentModel> get comments => _comments.value;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  String _postId = '';

  updatePostId(id) {
    _postId = id;
    getComment();
    // log('data geted');
  }

  getComment() async {
    _comments.bindStream(
      firebaseFirestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot snapshot) {
          List<CommentModel> retVal = [];
          for (var element in snapshot.docs) {
            Map<String, dynamic>? data =
                element.data() as Map<String, dynamic>?;

            if (data != null) {
              retVal.add(CommentModel.fromMap(data));
            }
          }
          return retVal;
        },
      ),
    );
  }

  Future<void> postComment(String comment) async {
    try {
      if (comment.isNotEmpty) {
        DocumentSnapshot userDoc = await firebaseFirestore
            .collection('users')
            .doc(authController.user.uid)
            .get();

        var allDocs = await firebaseFirestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();

        int len = allDocs.docs.length;

        CommentModel commentModel = CommentModel(
          username: (userDoc.data() as dynamic)['username'],
          comment: comment.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data() as dynamic)['profilePic'],
          uid: authController.user.uid,
          id: 'Comment $len',
        );

        await firebaseFirestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc("Comment $len")
            .set(
              commentModel.toMap(),
            );

        DocumentSnapshot doc =
            await firebaseFirestore.collection("videos").doc(_postId).get();

        if (doc.exists) {
          firebaseFirestore.collection("videos").doc(_postId).update({
            "commentCount": (doc.data()! as dynamic)['commentCount'] + 1,
          });
        } else {
          log("$doc Document does not exist");
        }
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error while commenting', 'Error is $e');
    }
  }

  likeComment(id) async {
    var uid = authController.user.uid;

    DocumentSnapshot doc = await firebaseFirestore
        .collection("videos")
        .doc(_postId)
        .collection("comments")
        .doc(id)
        .get();

    if (doc.exists) {
      dynamic likesData = (doc.data()! as dynamic)['likes'];
      if (likesData != null && likesData.contains(uid)) {
        await firebaseFirestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    }
    // else {
    //   print('Document does not exist');
    // }
  }
}
