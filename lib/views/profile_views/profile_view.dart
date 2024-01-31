import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/bottom_controller/bottom_controller.dart';
import 'package:tiktok_clone/controllers/profile_controllers/profile_controller.dart';
import 'package:tiktok_clone/utils/colors.dart';
import 'package:tiktok_clone/utils/global_var.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = Get.put(ProfileController());

  @override
  void initState() {
    _controller.updateProfile(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("getuser${widget.uid} currentuser${authController.user.uid}");
    return SafeArea(
      child: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          var data = _controller.user;
          if (data.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Utils.backgroundColor,
              centerTitle: true,
              leading: const BackButton(),
              title: Text(data['name']),
              actions: const [
                Icon(Icons.more_horiz),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: data['profilePic'],
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _profileData(
                      data: data['following'],
                      text: 'Following',
                    ),
                    const SizedBox(width: 15),
                    _profileData(
                      data: data['followers'],
                      text: 'Followers',
                    ),
                    const SizedBox(width: 15),
                    _profileData(
                      data: data['likes'],
                      text: 'Likes',
                    ),
                  ],
                ),
                Obx(
                  () => TextButton(
                    onPressed: () {
                      if (widget.uid == authController.user.uid) {
                        authController.signOut();
                        Get.find<BottomController>().updateIndex(0);
                      } else {
                        _controller.followUser();
                        log(data["isFollowing"].toString());
                      }
                    },
                    child: Text(
                      widget.uid == authController.user.uid
                          ? 'Sign Out'
                          : data["isFollowing"]
                              ? "UnFollow"
                              : "follow",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: GridView.builder(
                        itemCount: _controller.thumbnail.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                          childAspectRatio: Get.height / Get.height * 0.8,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (_, index) {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 200,
                            imageUrl: _controller.thumbnail[index],
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Column _profileData({required String data, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          data,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text),
      ],
    );
  }
}
