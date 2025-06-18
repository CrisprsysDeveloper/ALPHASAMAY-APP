import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TokenRepository authRepository;

  LoginController({required this.authRepository});

  final TextEditingController textUserName = TextEditingController();
  final TextEditingController textPassword = TextEditingController();

  var isRememberMe = true.obs;


  @override
  void onInit() {
    super.onInit();
    printf('<------init--LoginController----->');
  }
}
