import 'dart:convert';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/screens/authentication/otp_screen.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';

class AuthenticationController extends GetxController {
  final TokenRepository authRepository;

  AuthenticationController({required this.authRepository});

  final TextEditingController textCompany = TextEditingController();
  final TextEditingController textEmail = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    printf('<------init--AuthenticationController----->');
    textCompany.text = '1';
  }

  @override
  void onClose() {
    textCompany.dispose();
    textEmail.dispose();
    super.onClose();
  }

  void buttonSubmit() {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    if (textCompany.text.isEmpty) {
      dropDownBannerError('Please enter valid company id');
    } else if (textCompany.text.isEmpty) {
      dropDownBannerError('Please enter email');
    } else if (!regex.hasMatch(textEmail.text)) {
      dropDownBannerError('Please enter valid email'); // Add this constant
    } else {
      getOtpApi(
        clientId: textCompany.text,
        userName: 'CALL',
        email: textEmail.text,
      );
    }
  }

  Future<void> getOtpApi({
    required String clientId,
    required String userName,
    required String email,
  }) async {
    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint =
        AppConstants
            .clientAuthenticationApi; //"/api/ClientAuthorization/GetCrisprsysMobAppOTP";

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'Email': email,
          },
        );

        printf('<----response---->$response');

        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        // Step 2: Decode the nested JSON string in "ServiceStatus"
        final Map<String, dynamic> serviceStatus = jsonDecode(
          outerJson['ServiceStatus'],
        );

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        if (messageCode == "200") {
          Get.to(() => OtpScreen(clientID: clientId, email: email));
        } else {
          dropDownBannerError(messageDescription);
        }
        hideProgress();
      } catch (e) {
        printf("Exception: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }
}

// <----response---->{"ServiceStatus":"{\"MessageCode\":\"370\",\"MessageDescription\":\"Email ID is not registered\"}"}

// <----response---->{"ServiceStatus":"{\"MessageCode\":\"200\",\"MessageDescription\":\"Success\"}"}
