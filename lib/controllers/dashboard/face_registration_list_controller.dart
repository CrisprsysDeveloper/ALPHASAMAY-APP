import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../helper/snackbar_toast.dart';
import '../../model/dashboard/face_recognition_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/utility.dart';

class FaceRegistrationListController extends GetxController {
  final TokenRepository authRepository;

  FaceRegistrationListController({required this.authRepository});

  final box = GetStorage();

  RxList<AttendanceUser> faceUserList = <AttendanceUser>[].obs;
  RxList<ScreenControl> screenControls = <ScreenControl>[].obs;
  String selectedYear = '2025';
  String selectedMonth = 'February';

  String firstDay = '';
  String lastDay = '';

  var clientId = '1';
  var userName = 'Call';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--TimeEventOverController----->');
    loadSavedCredentials();
    getCurrentLocation();
    DateTime now = DateTime.now();
    getFirstAndLastDay(now.year, now.month);
  }

  void loadSavedCredentials() {
    final savedUsername = box.read(AppConstants.prefUsername);
    final companyId = box.read(AppConstants.prefClientID);

    if (savedUsername != null) {
      userName = savedUsername;
    }

    if (companyId != null) {
      clientId = companyId;
    }

    printf('<---userName-->$userName---clientId--->$clientId');
  }

  String dateToYMD(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void getFirstAndLastDay(int year, int month) {
    DateTime fd = DateTime(year, month, 1);
    DateTime ld = DateTime(year, month + 1, 0);

    firstDay = dateToYMD(fd);
    lastDay = dateToYMD(ld);

    printf("First day: $firstDay");
    printf("Last day: $lastDay");

    getFaceUserListApi(
      clientId: clientId,
      userName: userName,
    );
  }

  Future<void> getFaceUserListApi({
    required String clientId,
    required String userName,
  }) async {
    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.faceRecognitionListApi;
    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'BusObjCode': 'CRIS_BUS_GS_FaceRegistration_OV',
            'RequestComingFrom': 'Web',
          },
        );

        printf('<----response---->$response');

        final data = jsonDecode(response.data);
        final model = FaceRecognitionResponse.fromJson(data);

        if (model.serviceStatus.messageCode == "200") {
          faceUserList.value = model.attendanceUserList;
          screenControls.value = model.screenControlsList;

          printf("User Count: ${faceUserList.length}");
          printf("Controls: ${screenControls.map((e) => e.control).toList()}");
        } else {
          dropDownBannerError(model.serviceStatus.messageDescription);
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

  Future<void> deleteEventApi({
    required String clientId,
    required String userName,
    required String eventId,
  }) async {
    printf('<--clientId-$clientId--userName-->$userName--eventId-->$eventId');

    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.deleteEventApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'AttendEventID': eventId,
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
          printf('<----success-delete-event---refresh-event-list-here->');

          // getEventListApi(
          //   clientId: clientId,
          //   userName: userName,
          //   empNo: '',
          //   startDay: firstDay,
          //   endDay: lastDay,
          // );
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

  void showDeleteEventDialog() {
    showDialog(
      context: Get.context!,
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
                  "Do you want to delete this Face Registration?",
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
                        Get.back(); // Close the current route
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

  Future<void> getCurrentLocation() async {
    String location = "Fetching...";
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location = "Location services are disabled.";
      update();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        location = "Location permission denied.";
        update();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      location = "Location permissions are permanently denied.";
      update();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    location =
    "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    update();

    printf("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }
}
