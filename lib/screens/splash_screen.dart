import 'package:crysprsys/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(
        init: SplashController(context),
        builder: (controller) {
          return SizedBox(
            height: Get.height,
            width: Get.width,
            child: Center(child: Text('Splash Screen')),
          );
        },
      ),
    );
  }
}
