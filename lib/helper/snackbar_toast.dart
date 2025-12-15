import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

dropDownBannerWarning(String message) {
  Get.snackbar(
    'Warning',
    message,
    backgroundColor: Colors.orange[100],
    borderWidth: 2,
    borderColor: Colors.orange[400],
  );
}

dropDownBannerError(String message, {duration = 1000}) {
  Get.snackbar(
    'Failed',
    message,
    duration: Duration(milliseconds: duration),
    backgroundColor: Colors.redAccent,
    borderWidth: 1,
    colorText: Colors.white,
    borderColor: Colors.white,
  );
}

dropDownBannerSuccess(String message, {duration = 1000}) {
  Get.snackbar(
    'Success',
    message,
    duration: Duration(milliseconds: duration),
    backgroundColor: Colors.green,
    borderWidth: 1,
    colorText: Colors.white,
    borderColor: Colors.white,
  );
}

void dropDownBannerInfo(String message) {
  Get.snackbar(
    'Info',
    message,
    backgroundColor: Colors.blue[100],
    borderWidth: 2,
    borderColor: Colors.blue[400],
  );
}

dropDownBanner(Color color, String message) {}

showProgress() {
  Get.context!.loaderOverlay.show();
}

hideProgress() {
  Get.context!.loaderOverlay.hide();
}
