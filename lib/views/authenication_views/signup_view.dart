// ignore_for_file: unnecessary_cast, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/authentication_controllers/auth_controller.dart';
import 'package:tiktok_clone/utils/global_var.dart';
import 'package:tiktok_clone/utils/regex.dart';

import '../../utils/colors.dart';

AuthController _controller = Get.put(AuthController());

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: authController.signUpKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: GestureDetector(
                    onTap: () {
                      authController.pickImage();
                    },
                    child: Obx(() => CircleAvatar(
                          radius: 50,
                          backgroundImage: authController.pickImg != null
                              ? FileImage(authController.pickImg!)
                                  as ImageProvider<Object>?
                              : AssetImage('assets/default_img.jpg')
                                  as ImageProvider<Object>?,
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) =>
                      input!.isValidEmail() ? null : "Check your email",
                  controller: controller.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                Obx(() => TextFormField(
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => input!.isValidPassword()
                          ? null
                          : "Check your Password",
                      controller: _controller.passwordController,
                      obscureText: authController.showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            authController.toggleShowPassword();
                          },
                          icon: Icon(Icons.visibility_off),
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (input) => input!.isNotEmpty ? null : "required*",
                  controller: _controller.usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (input) => input!.isNotEmpty ? null : "required*",
                  controller: _controller.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (authController.signUpKey.currentState!.validate()) {
                      authController.registerUser(
                        _controller.usernameController.text,
                        _controller.emailController.text,
                        _controller.usernameController.text,
                        _controller.passwordController.text,
                        authController.pickImg,
                      );
                    }
                  },
                  child: const Text('Sign Up'),
                ),
                SizedBox(height: Get.height * 0.17),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: 'Already have account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                              color: Utils.primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
