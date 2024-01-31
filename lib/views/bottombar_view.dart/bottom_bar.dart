import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/bottom_controller/bottom_controller.dart';
import 'package:tiktok_clone/utils/colors.dart';

import '../../utils/widgets/add_button.dart';

BottomController _controller = Get.put(BottomController());

class BottomBarView extends GetView<BottomController> {
  const BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    log("page index is ${_controller.index}");
    return Scaffold(
      bottomSheet: Obx(
        () => BottomNavigationBar(
          backgroundColor: Utils.backgroundColor,
          selectedItemColor: Utils.primaryColor,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            _controller.updateIndex(value);
          },
          currentIndex: _controller.index,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: addVideoBtn,
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profie',
            ),
          ],
        ),
      ),
      body: Obx(
        () => _controller.screens[_controller.index],
      ),
    );
  }
}
