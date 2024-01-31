import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/utils/global_var.dart';

class ProfileSearchController extends GetxController {
  final Rx<List<UserModel>> _searchUser = Rx<List<UserModel>>([]);
  TextEditingController searchController = TextEditingController();

  List<UserModel> get searchUser => _searchUser.value;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void getUser(String typeUser) async {
    List<UserModel> retVal = [];
    _searchUser.bindStream(firebaseFirestore
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: typeUser)
        .snapshots()
        .map((QuerySnapshot query) {
      retVal.clear(); // Clear previous results
      for (var doc in query.docs) {
        var data = doc.data() as Map<String, dynamic>?; // Handle nullable data
        if (data != null) {
          retVal.add(UserModel.fromMap(data)); // Convert data to UserModel
        }
      }
      return retVal;
    }));
  }
}
