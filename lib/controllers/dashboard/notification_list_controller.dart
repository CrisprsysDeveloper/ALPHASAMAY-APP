import 'dart:convert';
import 'package:crysprsys/model/notification/notification_list_model.dart';
import 'package:intl/intl.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NotificationListController extends GetxController {
  final TokenRepository authRepository;

  NotificationListController({required this.authRepository});

  final box = GetStorage();

  var clientId = '1';
  var userName = 'Call';
  var roleCode = '';

  RxList<ObjUNotification> notifications = <ObjUNotification>[].obs;


  @override
  void onInit() {
    super.onInit();
    printf('<------init--NotificationListController----->');
    loadSavedCredentials();
  }

  void loadSavedCredentials() {
    final savedUsername = box.read(AppConstants.prefUsername);
    final companyId = box.read(AppConstants.prefClientID);
    roleCode = box.read(AppConstants.prefRoleCode);
    if (savedUsername != null) {
      userName = savedUsername;
    }

    if (companyId != null) {
      clientId = companyId;
    }

    printf(
      '<---userName-->$userName---clientId--->$clientId--role-code-->$roleCode',
    );
    getNotificationList(
      clientId: clientId,
      userName: userName,
      roleCode: roleCode,
    );
  }

  Future<void> getNotificationList({
    required String clientId,
    required String userName,
    required String roleCode,
  }) async {
    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.getNotificationListApi;
    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        DateTime now = DateTime.now();
        String todayDate = DateFormat('yyyy-MM-dd').format(now);

        final queryParameters = {
          'CPMClientID': clientId,
          'CPMUserName': userName,
          'Type': 'MyNotifications',
          'Date': todayDate,
          'Role': roleCode,
          'Notification_ID': '',
          'FiltersList': '',
        };

        final uri = Uri.parse(
          '$baseUrl$endpoint',
        ).replace(queryParameters: queryParameters);

        printf('Request URL: $uri'); // 👈 prints full

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'Type': 'MyNotifications',
            'Date': '',
            'Role': '',
            'Notification_ID': '',
            'FiltersList': '',
          },
        );

        printf('<----response---->$response');
        if (response.statusCode == 200 && response.data != null) {
          final responseJson = response.data;

          final List<NotificationData> notificationDataList =
              (responseJson['data'] as List<dynamic>?)
                  ?.map((e) => NotificationData.fromJson(e))
                  .toList() ??
              [];

          final List<ObjUNotification> allNotifications =
              notificationDataList
                  .expand((data) => data.objUNotification)
                  .toList();

          notifications.value = allNotifications;

          printf('Total notifications loaded: ${notifications.length}');

          printf('Notifications count: ${allNotifications.length}');

          for (var notification in allNotifications) {
            printf(
              'Notification No: ${notification.notificationNo}, Status: ${notification.notification_Status}',
            );
          }
        }

        hideProgress();
      } catch (e) {
        printf("Error: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> notificationView({
    required String clientId,
    required String userName,
    required String notificationNo,
  }) async {
    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.viewNotificationApi;
    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final queryParameters = {
          'CPMClientID': clientId,
          'CPMUserName': userName,
          'NotificationNo': notificationNo,
          'Date': '',
        };

        final uri = Uri.parse(
          '$baseUrl$endpoint',
        ).replace(queryParameters: queryParameters);

        printf('Request URL: $uri'); // 👈 prints full

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'NotificationNo': notificationNo,
            'Date': '',
          },
        );

        printf('<----response--notification-view-->$response');

        hideProgress();
      } catch (e) {
        printf("Error: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }
}
