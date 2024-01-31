import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/add_video_controller/add_video_controller.dart';
import 'package:tiktok_clone/utils/colors.dart';
import 'package:tiktok_clone/utils/componnets/custom_button.dart';
import 'package:tiktok_clone/utils/componnets/custom_field.dart';
import 'package:video_player/video_player.dart';

AddVideoController _controller = Get.put(AddVideoController());

class ConfirmView extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmView({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<ConfirmView> createState() => _ConfirmViewState();
}

class _ConfirmViewState extends State<ConfirmView> {
  @override
  void initState() {
    super.initState();
    _controller.videoPlayerController =
        VideoPlayerController.file(widget.videoFile);
    _controller.videoPlayerController.initialize();
    _controller.videoPlayerController.play();
    _controller.videoPlayerController.setVolume(1);
    _controller.videoPlayerController.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: VideoPlayer(_controller.videoPlayerController),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // height: Get.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   width: MediaQuery.of(context).size.width - 20,
                  //   margin: const EdgeInsets.only(left: 10, right: 10),
                  //   child: CustomTextField(
                  //     controller: _controller.songController,
                  //     prefixIcon: const Icon(Icons.music_note),
                  //     labelText: 'Song Name',
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomTextField(
                      controller: _controller.captionController,
                      prefixIcon: const Icon(Icons.music_note),
                      labelText: 'Caption',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomButton(
                      text: 'Share',
                      onTap: () {
                        _controller.uploadVideo(
                          // _controller.songController.text,
                          _controller.captionController.text,
                          widget.videoPath,
                        );
                      },
                      color: Utils.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
