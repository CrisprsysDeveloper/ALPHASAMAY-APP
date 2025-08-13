import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/model/authentication/login_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/screens/authentication/set_pin_screen.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class LoginController extends GetxController {
  final TokenRepository authRepository;

  LoginController({required this.authRepository});

  final TextEditingController textUserName = TextEditingController();
  final TextEditingController textPassword = TextEditingController();

  final listAuthorizedApps = <AuthorizedApplication>[].obs;
  final listAuthorizedComponents = <AuthorizedComponent>[].obs;
  final listAuthorizedBusinessObjects = <AuthorizedBusinessObject>[].obs;

  var isRememberMe = false.obs;
  final box = GetStorage();

  var clientId = '1';
  var setPin = '';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--LoginController----->');
    loadSavedCredentials();
    printf('<---clientId--->$clientId');
  }

  Future<void> buttonLogin() async {
    if (textUserName.text.isEmpty) {
      dropDownBannerError('Please enter username');
    } else if (textPassword.text.isEmpty) {
      dropDownBannerError('Please enter password');
    } else {
      if (isRememberMe.value) {
        await GetStorage().write(AppConstants.prefUsername, textUserName.text);
        await GetStorage().write(AppConstants.prefPassword, textPassword.text);
      } else {
        await box.remove(AppConstants.prefUsername);
        await box.remove(AppConstants.prefPassword);
      }
      loginApi(
        clientId: clientId,
        userName: textUserName.text,
        password: textPassword.text,
      );
      //   Get.to(() => SetPinScreen());
    }
  }

  Future<void> loginApi({
    required String clientId,
    required String userName,
    required String password,
  }) async {
    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.loginApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'clientId': clientId,
            'userName': userName,
            'passWord': password,
          },
        );

        printf('<----login-api-url----> ${response.realUri}');
        printf('<----login-api-response----> ${response.data}');

        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        final String serviceStatusRaw = outerJson['ServiceStatus'];
        final Map<String, dynamic> serviceStatus = jsonDecode(serviceStatusRaw);

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        // if (messageCode == "200")
        // {
        //   final List<dynamic> tokenList = outerJson['token'] ?? [];
        //   final String? token = tokenList.isNotEmpty ? tokenList[0] : null;
        //   printf('Token: $token');
        //
        //   final Map<String, dynamic> listOfApplications =
        //       outerJson['ListOfApplications'];
        //
        //   final List<dynamic> appJsonList =
        //       listOfApplications['listOfAuthorizedApplications'] ?? [];
        //
        //   printf('listOfAuthorizedApplications: ${appJsonList.length}');
        //
        //   // Parse components
        //   final List<dynamic> componentJsonList =
        //       listOfApplications['listOfAuthorizedComponents'] ?? [];
        //
        //   final List<AuthorizedComponent> authorizedComponents =
        //       componentJsonList
        //           .map((compJson) => AuthorizedComponent.fromJson(compJson))
        //           .toList();
        //
        //   final List<Map<String, dynamic>> componentJsonListForStorage =
        //       authorizedComponents.map((comp) => comp.toJson()).toList();
        //
        //   await GetStorage().write(
        //     'authorizedComponents',
        //     componentJsonListForStorage,
        //   );
        //
        //   for (var comp in authorizedComponents) {
        //     printf(
        //       'Component: ${comp.componentCode}, ${comp.componentName}, ${comp.url}',
        //     );
        //   }
        //
        //   printf('<---set-pin--->$setPin');
        //   await GetStorage().write(AppConstants.isLoggedIn, true);
        //   if (setPin == 'null' || setPin.isEmpty) {
        //     Get.to(() => SetPinScreen(from: 'login'));
        //     // Get.offAll(() => SetPinScreen(from: 'login'));
        //   } else {
        //     Get.to(() => SetPinScreen(from: 'login'));
        //     // Get.offAll(() => SetPinScreen(from: 'login'));
        //     printf('<---navigate-to-dashboard--->');
        //   }
        // } else {
        //   dropDownBannerError(messageDescription);
        // }

        hideProgress();
      } catch (e, stackTrace) {
        printf("Exception: $e");
        printf("StackTrace: $stackTrace");
        dropDownBannerError("Something went wrong. Please try again.");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> loginApiOld({
    required String clientId,
    required String userName,
    required String password,
  }) async {
    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.loginApi;

    try {
      showProgress();
      final response = await dio.get(
        '$baseUrl$endpoint',
        queryParameters: {
          'clientId': clientId,
          'userName': userName,
          'passWord': password,
        },
      );
      printf('<----login-api-url---->${response.realUri}');
      printf('<----login-api-response---->$response');

      final Map<String, dynamic> outerJson = jsonDecode(response.data);

      final Map<String, dynamic> serviceStatus = jsonDecode(
        outerJson['ServiceStatus'],
      );

      final String messageCode = serviceStatus['MessageCode'];
      final String messageDescription = serviceStatus['MessageDescription'];

      printf('MessageCode: $messageCode');
      printf('MessageDescription: $messageDescription');

      if (messageCode == "200") {
      } else {
        dropDownBannerError(messageDescription);
      }
      hideProgress();
    } catch (e) {
      printf("Exception: $e");
      hideProgress();
    }
  }

  void loadSavedCredentials() {
    final savedUsername = box.read(AppConstants.prefUsername);
    final savedPassword = box.read(AppConstants.prefPassword);
    final companyId = box.read(AppConstants.prefClientID);
    final pin = box.read(AppConstants.prefPIN);

    if (savedUsername != null && savedPassword != null) {
      textUserName.text = savedUsername;
      textPassword.text = savedPassword;
      isRememberMe.value = true;
    }

    if (companyId != null) {
      clientId = companyId;
    }

    if (pin != null) {
      setPin = pin;
    }

    printf('<---set-pin--->$pin');
  }
}
