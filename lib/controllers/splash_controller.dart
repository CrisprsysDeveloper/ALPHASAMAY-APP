import 'dart:async';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/screens/authentication/set_pin_screen.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  BuildContext context;

  SplashController(this.context);

  bool isUserLogin = false;

  var version = '';

  final box = GetStorage();
  var setPin = '';

  @override
  void onInit() {
    super.onInit();
    loadBuildNumber();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('<---init-SplashController--->');
      loadSavedCredentials();
      _route();
    });
  }

  void loadSavedCredentials() {
    final pin = box.read(AppConstants.prefPIN);

    if (pin != null) {
      setPin = pin;
    }
    printf('<--splash-set-pin--->$pin');
  }

  Future<void> loadBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = "V.${packageInfo.version}+${packageInfo.buildNumber}";
    update();
  }

  void _route() async {
    await Future.delayed(const Duration(seconds: 2));

    Get.offAndToNamed(Routes.dashboardScreen);

    // if (setPin.isNotEmpty) {
    //   Get.offAll(() => SetPinScreen());
    // } else {
    //   redirect();
    // }

  }

  Future<void> redirect() async {
    Get.offAndToNamed(Routes.loginScreen);
  }
}
