import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

dropDownBannerWarning(String message) {
  Get.snackbar('Warning', message,
      backgroundColor: Colors.orange[100],
      borderWidth: 2,
      borderColor: Colors.orange[400]);
}

dropDownBannerError(String message) {
  bool isDark = Get.isDarkMode;

  Get.snackbar('Failed', message,
      backgroundColor: isDark ? ColorConstants.backgroundColor : Colors.white,
      borderWidth: 1,
      //colorText: Colors.white,
      borderColor: isDark
          ? ColorConstants.btnBorderColor
          : ColorConstants.btnBorderColorForWhite);
}

dropDownBannerSuccess(String message, {duration = 5000}) {
  Get.snackbar('Success', message,
      duration: Duration(milliseconds: duration),
      backgroundColor:  Colors.green[400],
      borderWidth: 1,
      borderColor: Colors.green[200]);
}

void dropDownBannerInfo(String message) {
  Get.snackbar('Info', message,
      backgroundColor: Colors.blue[100],
      borderWidth: 2,
      borderColor: Colors.blue[400]);
}

dropDownBanner(Color color, String message) {}

showProgress() {
  Get.context!.loaderOverlay.show();
}

hideProgress() {
  Get.context!.loaderOverlay.hide();
}
