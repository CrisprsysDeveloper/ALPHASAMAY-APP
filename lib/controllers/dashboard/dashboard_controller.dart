import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/screens/dashboard/my_account.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:convert';

class DashboardController extends GetxController {
  final TokenRepository authRepository;

  DashboardController({required this.authRepository});

  RootModel? rootModel;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    printf('<------init--DashboardController----->');
  }

  Future<void> getUerAccountDetails({
    required String clientId,
    required String userName,
  }) async {
    final dio = Dio();
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getMyAccountDetailApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final fullUrl =
            Uri.parse('$baseUrl$endpoint')
                .replace(
                  queryParameters: {
                    'CPMClientID': clientId,
                    'CPMUserName': userName,
                    'flag': '',
                  },
                )
                .toString();

        printf('Full URL: $fullUrl');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'flag': '',
          },
        );

        printf('<----response---->${response.data}');

        final Map<String, dynamic> jsonMap =
            response.data is String
                ? json.decode(response.data)
                : response.data;

        // Decode the stringified ServiceStatus
        final serviceStatus = json.decode(jsonMap['ServiceStatus'] ?? '{}');

        if (serviceStatus['MessageCode'] == "200") {
          rootModel = RootModel.fromJson(jsonMap); // ✅ Assigned here

          printf('User Name: ${rootModel?.userProfileList.first.userName}');
          printf('Email: ${rootModel?.userProfileList.first.email}');

          await GetStorage().write(
            AppConstants.prefEmpName,
            rootModel?.userRoleAssignments.first.userName,
          );
          await GetStorage().write(
            AppConstants.prefRole,
            rootModel?.userRoleAssignments.first.role,
          );
          await GetStorage().write(
            AppConstants.prefRoleCode,
            rootModel?.userRoleAssignments.first.roleCode,
          );
          await GetStorage().write(
            AppConstants.prefUserId,
            rootModel?.userProfileList.first.userID.toString(),
          );
          await GetStorage().write(
            AppConstants.prefPENRId,
            rootModel?.userProfileList.first.pernr.toString(),
          );
        } else {
          dropDownBannerError(
            serviceStatus['MessageDescription'] ?? "Unknown error",
          );
        }

        hideProgress();
      } catch (e, stackTrace) {
        printf("Exception: $e");
        printf("StackTrace: $stackTrace");
        dropDownBannerError("Something went wrong. Please try again.");

        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);

      hideProgress();
    }
  }

  void buttonLogout() {
    showLogoutDialog(Get.context!);
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirmation",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text("NO", style: TextStyle(color: Colors.blue)),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: Text("YES", style: TextStyle(color: Colors.blue)),
                      onPressed: () async {
                        await GetStorage().write(
                          AppConstants.isLoggedIn,
                          false,
                        );
                        //await GetStorage().erase();
                        Get.back(); // Close the current route
                        Get.offAllNamed(Routes.loginScreen);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
