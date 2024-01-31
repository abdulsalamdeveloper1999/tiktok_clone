import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/home_controller/home_controller.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/utils/global_var.dart';
import 'package:tiktok_clone/views/home_view.dart/comment_view.dart';
import 'package:tiktok_clone/views/profile_views/profile_view.dart';

import 'circle_animation.dart';

HomeController _controller = Get.put(HomeController());

class VideoDetailsCard extends StatelessWidget {
  final VideoModel videoModel;
  const VideoDetailsCard({super.key, required this.videoModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Expanded(
            child: buildVideoDetails(),
          ),
          Container(
            width: 100,
            margin: EdgeInsets.only(top: Get.height / 5),
            child: buildActions(),
          ),
        ],
      ),
    );
  }

  Widget buildVideoDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          videoModel.username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          videoModel.songCaption,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        // Text(
        //   videoModel.songName,
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 15,
        //   ),
        // ),
      ],
    );
  }

  Widget buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () {
            Get.to(
              () => ProfileScreen(uid: videoModel.uid),
            );
          },
          child: Stack(
            children: [
              buildProfile(videoModel.profilePhoto),
              const Positioned(
                right: 0,
                bottom: 0,
                left: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        buildIconWithText(
          Icons.favorite,
          color: videoModel.likes.contains(authController.user.uid)
              ? Colors.red
              : Colors.white,
          videoModel.likes.length.toString(),
          onTap: () {
            _controller.likeVideo(videoModel.id);
          },
        ),
        buildIconWithText(
          Icons.comment,
          videoModel.commentCount.toString(),
          color: Colors.white,
          onTap: () {
            log('message');
            Get.to(() => CommentView(
                  id: videoModel.id,
                ));
          },
        ),
        buildIconWithText(
          color: Colors.white,
          Icons.reply,
          videoModel.shareCount.toString(),
          onTap: () {},
        ),
        CircleAnimations(
          child: buildMusicAlbum(videoModel.profilePhoto),
        ),
        const SizedBox(height: 7),
      ],
    );
  }

  Widget buildIconWithText(
    IconData icon,
    String text, {
    required Function() onTap,
    Color? color,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 40,
            color: color,
          ),
        ),
        Text(text),
        const SizedBox(height: 7),
      ],
    );
  }

  Widget buildProfile(String profilePic) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  imageUrl: profilePic,
                  errorWidget: (context, url, error) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                  placeholder: (context, url) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

buildMusicAlbum(String profilePic) {
  return SizedBox(
    // width: 60,
    // height: 60,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.grey,
                Colors.white,
              ],
            ),
            borderRadius: BorderRadiusDirectional.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              profilePic,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}
