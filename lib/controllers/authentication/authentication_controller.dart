import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final TokenRepository authRepository;

  AuthenticationController({required this.authRepository});

  final TextEditingController textCompany = TextEditingController();
  final TextEditingController textEmail = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    printf('<------init--AuthenticationController----->');
  }
}
