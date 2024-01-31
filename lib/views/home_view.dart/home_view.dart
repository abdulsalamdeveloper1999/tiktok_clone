import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/home_controller/home_controller.dart';
import 'package:tiktok_clone/views/home_view.dart/video_player.dart';
import 'package:tiktok_clone/views/profile_views/profile_view.dart';

import 'video_details.dart';

final HomeController _homeController = Get.put(HomeController());

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // log(_homeController.videoList.length.toString());
    return Scaffold(
      body: SizedBox(
          height: Get.height - 60,
          child: Obx(() => PageView.builder(
                itemCount: _homeController.videoList.length,
                scrollDirection: Axis.vertical,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                itemBuilder: (_, index) {
                  final videoData = _homeController.videoList[index];
                  // log(videoData.videoUrl);
                  return Stack(
                    children: [
                      VideoPlayerItem(videoUrl: videoData.videoUrl),
                      VideoDetailsCard(videoModel: videoData),
                    ],
                  );
                },
              ))),
    );
  }
}
