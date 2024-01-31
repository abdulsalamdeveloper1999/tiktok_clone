import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {Color? color}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final controller = AnimationController(
    vsync: scaffoldMessenger,
    duration: const Duration(milliseconds: 400),
  );

  final animation = Tween<Offset>(
    begin: const Offset(0, -1), // Start off the screen (above)
    end: const Offset(0, 0), // End position (at the top)
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  ));

  controller.forward();

  final snackBar = SnackBar(
    duration: const Duration(seconds: 2),
    content: SlideTransition(
      position: animation,
      child: Text(text),
    ),
    backgroundColor: color, // Optional background color
    // margin: EdgeInsets.only(
    //   bottom: MediaQuery.of(context).size.height - 100,
    //   right: 20,
    //   left: 20,
    // ),
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.up,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  scaffoldMessenger.showSnackBar(snackBar).closed.then((reason) {
    if (reason == SnackBarClosedReason.dismiss) {
      controller.dispose();
    }
  });
}
