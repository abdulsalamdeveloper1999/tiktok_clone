import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/utils/colors.dart';
import 'package:tiktok_clone/utils/global_var.dart';

import '../../controllers/authentication_controllers/auth_controller.dart';

// AuthController _controller = Get.put(AuthController());

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.232),
                  const Text(
                    "Tiktok Clone",
                    style: TextStyle(
                        color: Utils.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    validator: (input) =>
                        input!.isNotEmpty ? null : 'required*',
                    controller: authController.emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => TextFormField(
                      validator: (input) =>
                          input!.isNotEmpty ? null : 'required*',
                      obscureText: authController.showPassword,
                      controller: authController.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            authController.toggleShowPassword();
                          },
                          icon: const Icon(Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        authController.login(
                          authController.emailController.text,
                          authController.passwordController.text,
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  SizedBox(height: Get.height * 0.23),
                  GestureDetector(
                    onTap: () => authController.gotoSignUp(),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: 'Dont have account? '),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Utils.primaryColor,
                              fontSize: 16,
                            ),
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
      ),
    );
  }
}
