import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final TokenRepository authRepository;

  DashboardController({required this.authRepository});

  @override
  void onInit() {
    super.onInit();
    printf('<------init--DashboardController----->');
  }
}
