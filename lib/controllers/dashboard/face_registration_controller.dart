import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceRegistrationController extends GetxController {
  final TokenRepository authRepository;

  FaceRegistrationController({required this.authRepository});

  String selectedYear = 'Business Object';
  String selectedMonth = 'Object Number';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--FaceRegistrationController----->');
  }
}
