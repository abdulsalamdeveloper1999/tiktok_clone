import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/controllers/add_video_controller/add_video_controller.dart';
import 'package:tiktok_clone/utils/colors.dart';

AddVideoController _controller = Get.put(AddVideoController());

class AddVideoView extends GetView<AddVideoController> {
  const AddVideoView({super.key});

  showOptionsDialog(context) {
    return showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  _controller.pickVideo(ImageSource.gallery, context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.image),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        'Gallery',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _controller.pickVideo(ImageSource.camera, context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        'Camera',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Row(
                  children: [
                    Icon(Icons.cancel),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: InkWell(
        onTap: () {
          showOptionsDialog(context);
        },
        child: Container(
          width: 190,
          height: 50,
          decoration: const BoxDecoration(color: Utils.primaryColor),
          child: const Center(
            child: Text(
              'Add Video',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
