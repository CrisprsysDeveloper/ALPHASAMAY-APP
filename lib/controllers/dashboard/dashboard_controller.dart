import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/model/authentication/login_model.dart';
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

  // Add dashboard data property
  Map<String, dynamic>? dashboardData;
  RxBool isLoadingDashboard = false.obs;

  RxString title = 'Dashboard'.obs; //AppConstants.workForceManagement.obs;
  RxList<AuthorizedComponent> authorizedComponentList = <AuthorizedComponent>[].obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--DashboardController----->');
    // Load dashboard data when controller initializes
    _initializeDashboard();

    // final List<dynamic> storedList =
    //     GetStorage().read('authorizedComponents') ?? [];
    //
    // final List<AuthorizedComponent> authorizedComponents =
    //     storedList.map((item) => AuthorizedComponent.fromJson(item)).toList();
    //
    // for (var comp in authorizedComponents) {
    //   printf(
    //     'Dashboard Component: ${comp.componentCode}, ${comp.componentName}, ${comp.url}',
    //   );
    //   title.value = comp.componentName.toString();
    // }

    final List<dynamic> storedList =
        GetStorage().read('authorizedComponents') ?? [];

    final List<AuthorizedComponent> components =
    storedList.map((item) => AuthorizedComponent.fromJson(item)).toList();

    authorizedComponentList.assignAll(components);

    if (authorizedComponentList.isNotEmpty) {
      title.value = authorizedComponentList.first.componentName;
    }

  }

  Future<void> _initializeDashboard() async {
    // First get user account details if not already loaded
    if (rootModel == null) {
      final clientId =
          await GetStorage().read(AppConstants.prefClientID) ?? "1";
      final userName =
          await GetStorage().read(AppConstants.prefUsername) ?? "Admin";

      if (clientId.isNotEmpty && userName.isNotEmpty) {
        await getUerAccountDetails(
          clientId: clientId,
          userName: userName,
        ).whenComplete(() {
          getDashboardData();
        });
      }
    }
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

  Future<void> getDashboardData() async {
    final dio = Dio();
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint =
        AppConstants.getDynamicDashboardsGetChnagedUserTemplateDataApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        isLoadingDashboard.value = true;
        showProgress();

        // Get stored user data
        String clientId =
            await GetStorage().read(AppConstants.prefClientID) ?? "1";
        String userName =
            await GetStorage().read(AppConstants.prefUsername) ?? "Admin";
        String userId = await GetStorage().read(AppConstants.prefUserId) ?? "1";
        String roleId = await GetStorage().read(AppConstants.prefRole) ?? "1";

        final queryParameters = {
          'ChangedTempCode': 'Time Attendance',
          'CPMClientID': clientId,
          'CPMUserName': userName,
          'UserID': userId,
          'RoleID': roleId,
          'MethodType': 'Mobile',
        };

        final fullUrl =
            Uri.parse(
              '$baseUrl$endpoint',
            ).replace(queryParameters: queryParameters).toString();

        printf('Dashboard API URL: $fullUrl');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: queryParameters,
        );

        printf('<----Dashboard Response---->${response.data}');

        final Map<String, dynamic> jsonMap =
            response.data is String
                ? json.decode(response.data)
                : response.data;

        if (jsonMap['MessageCode'] == "200") {
          dashboardData = jsonMap;
          printf('Dashboard data loaded successfully');
          printf(
            'Number of tiles: ${jsonMap['listofDashboardQueries']?.length ?? 0}',
          );
          update(); // Notify UI to rebuild
        } else {
          dropDownBannerError(
            jsonMap['Message'] ?? "Failed to load dashboard data",
          );
        }

        hideProgress();
        isLoadingDashboard.value = false;
      } catch (e, stackTrace) {
        printf("Dashboard API Exception: $e");
        printf("StackTrace: $stackTrace");
        dropDownBannerError("Failed to load dashboard data. Please try again.");
        hideProgress();
        isLoadingDashboard.value = false;
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
      hideProgress();
      isLoadingDashboard.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await getDashboardData();
  }

  void buttonLogout() {
    showLogoutDialog(Get.context!);
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                        Get.back();
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
