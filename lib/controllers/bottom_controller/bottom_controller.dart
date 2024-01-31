import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/utils/global_var.dart';
import 'package:tiktok_clone/views/profile_views/profile_view.dart';
import 'package:tiktok_clone/views/search_views/search_view.dart';

import '../../views/add_video_views/add_video_view.dart';
import '../../views/home_view.dart/home_view.dart';

class BottomController extends GetxController {
  final List<Widget> _screens = [
    const HomeView(),
    const SearchScreen(),
    const AddVideoView(),
    const Center(child: Text('Messages')),
    ProfileScreen(uid: authController.user.uid),
  ];

  @override
  void onReady() {
    super.onReady();
    // Reset index to 0 when the controller is initialized
    _index.value = 0;
  }

  List get screens => _screens;

  final RxInt _index = 0.obs;
  int get index => _index.value;

  void updateIndex(int value) {
    log(value.toString());
    _index.value = value;
  }
}
