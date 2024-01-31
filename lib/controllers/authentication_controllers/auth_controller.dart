import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/utils/colors.dart';
import 'package:tiktok_clone/utils/global_var.dart';
import 'package:tiktok_clone/views/authenication_views/signup_view.dart';
import 'package:tiktok_clone/views/bottombar_view.dart/bottom_bar.dart';
import '../../views/authenication_views/login_view.dart';
import '../bottom_controller/bottom_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    nameController.dispose();
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginView());
    } else {
      Get.offAll(() => const BottomBarView());
    }
  }

  late Rx<User?> _user;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _key;

  final GlobalKey<FormState> _signUpkey = GlobalKey<FormState>();

  GlobalKey<FormState> get signUpKey => _signUpkey;

  late Rx<File?> _pickImg;

  bool _isImagePickerActive = false;

  File? get pickImg => _pickImg.value;

  final RxBool _showPassword = true.obs;

  bool get showPassword => _showPassword.value;

  // final Rx<User?> _user = FirebaseAuth.instance.currentUser.obs;

  User get user => _user.value!;

  void toggleShowPassword() {
    _showPassword.toggle();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
  //     _user(newUser);
  //   });
  //   _pickImg = Rx<File?>(null);
  // }

  //User Persistant
  isUserLogin() {
    if (authController._user.value == null) {
      // User is not logged in, show login/register screen
      return const LoginView();
    } else {
      // User is logged in, reset index to 0 and show the main content
      Get.find<BottomController>().updateIndex(0); // Reset index to 0
      return const BottomBarView();
    }
  }

  //pick image from gallery
  pickImage() async {
    if (_isImagePickerActive) {
      // If image picker is already active, do nothing
      return;
    }

    _isImagePickerActive = true;

    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        Get.snackbar('Profile Picture',
            'You have successfully selected your profile picture');
        _pickImg.value = File(pickedImage.path);
      } else {
        Get.snackbar('Profile Picture', 'You have did\'nt pick any image');
      }
    } catch (e) {
      log('picker already active');
    } finally {
      _isImagePickerActive = false;
    }
  }

  //upload image to storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage.ref().child('profilePics').child(
          firebaseAuth.currentUser!.uid,
        );

    UploadTask uploadTask = ref.putFile(image);

    TaskSnapshot snap = await uploadTask;

    String downlaodUrl = await snap.ref.getDownloadURL();

    return downlaodUrl;
  }

  //register user in firebase
  Future<void> registerUser(
    String username,
    String email,
    String name,
    String password,
    File? image,
  ) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          name.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // Show a loading dialog
        Get.dialog(
          const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Utils.primaryColor,
                ),
                SizedBox(height: 10),
                Text("Creating Account..."),
              ],
            ),
          ),
        );

        // Save user to authentication
        final UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload image to Firebase storage
        String downloadUrl = await _uploadToStorage(image);

        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          username: username,
          email: email,
          name: name,
          profilePic: downloadUrl,
        );

        // Save user to Firestore
        await firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap())
            .then((value) {
          // Remove the loading dialog
          Get.back();

          Get.snackbar(
            'Account Created',
            'Your account has been successfully created.',
          );

          clearControllers();

          // Show a success message

          Get.offAll(() => const BottomBarView());
        });
      } else {
        // Show an error message for missing fields
        Get.snackbar('Error Creating Account', 'All fields are required');
      }
    } on FirebaseAuthException catch (e) {
      // Remove the loading dialog in case of an error
      Get.back();

      // Show an error message
      Get.snackbar('Error Creating Account', '${e.message}');
    }
  }

  //login user to app
  void login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      Get.dialog(
        const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Utils.primaryColor,
              ),
              SizedBox(height: 10),
              Text("Signing In"),
            ],
          ),
        ),
      );

      try {
        await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          // Close the dialog before navigating to the HomeView
          Get.back();
          Get.offAll(() => const BottomBarView());
        });
      } on FirebaseAuthException catch (e) {
        // Close the dialog in case of an exception
        Get.back();
        Get.snackbar('Error while logging in', '${e.message}');
      }
    } else {
      Get.snackbar('Error while logging in', 'Fields are required');
    }
  }

  //go to signup_view
  void gotoSignUp() {
    Get.to(() => const SignupView());
  }

  //clear comtroller
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    nameController.clear();
    _pickImg.value = null;
  }

  Future<void> signOut() async {
    firebaseAuth.signOut();
  }
}
