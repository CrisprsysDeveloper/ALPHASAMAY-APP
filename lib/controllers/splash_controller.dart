import 'dart:async';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  BuildContext context;

  SplashController(this.context);

  bool isUserLogin = false;

  var version = '';

  @override
  void onInit() {
    super.onInit();
    loadBuildNumber();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('<---init-SplashController--->');
      _route();
    });
  }

  Future<void> loadBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = "V.${packageInfo.version}+${packageInfo.buildNumber}";
    update();
  }

  void _route() async {
    await Future.delayed(const Duration(seconds: 2));
    redirect();
    // final isLoggedIn = GetStorage().read(AppConstants.isLoggedIn) ?? false;
    //
    // printf("<--check-login---->$isLoggedIn");
    //
    // if (isLoggedIn) {
    //   var userName = GetStorage().read(AppConstants.userName);
    //   if (userName != null)
    //   {
    //     Get.offNamed(Routes.dashboardScreen);
    //   } else {
    //     Get.offAllNamed(Routes.editProfileScreen,
    //         arguments: [AppConstants.fromOTP]);
    //   }
    // } else {
    //   redirect();
    // }
  }

  Future<void> redirect() async {
    Get.offAndToNamed(Routes.loginScreen);
  }
}
