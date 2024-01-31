import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller/search_controller.dart';
import '../../utils/colors.dart';
import '../profile_views/profile_view.dart';

final ProfileSearchController _controller = Get.put(ProfileSearchController());

class SearchScreen extends GetView<ProfileSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Utils.primaryColor,
            title: TextFormField(
              controller: _controller.searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                border: UnderlineInputBorder(),
              ),
              onFieldSubmitted: (value) {
                _controller.getUser(value);
              },
            ),
          ),
          body: _controller.searchUser.isEmpty
              ? const Center(
                  child: Text(
                    "no users",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _controller.searchUser.length,
                  itemBuilder: (context, index) {
                    var data = _controller.searchUser[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                              uid: data.uid,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data.profilePic),
                      ),
                      title: Text(data.name),
                    );
                  },
                ),
        );
      }),
    );
  }
}
