import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/authentication_controllers/auth_controller.dart';
import 'package:tiktok_clone/utils/colors.dart';
import 'firebase_options.dart';
import 'utils/global_var.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    //iniializing auth controller is here beacuse it will be use in overall app
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Utils.backgroundColor,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Utils.backgroundColor,
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Utils.primaryColor),
          ),
        ),
      ), // themeMode: ThemeMode.dark,
      home: Obx(() {
        return authController.isUserLogin();
      }),
    );
  }
}
