import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/model/dashboard/time_event_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class TimeEventOverController extends GetxController {
  final TokenRepository authRepository;

  TimeEventOverController({required this.authRepository});

  final box = GetStorage();

  RxList<Employee> employeeList = <Employee>[].obs;

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

    getEventListApi(
      clientId: clientId,
      userName: userName,
      empNo: '',
      startDay: firstDay,
      endDay: lastDay,
    );
  }

  Future<void> getEventListApi({
    required String clientId,
    required String userName,
    required String empNo,
    required String startDay,
    required String endDay,
  }) async {
    printf(
      '<--clientId-$clientId--userName-->$userName--start-day-->$startDay--end-day-->$endDay',
    );

    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.timeEventListApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final url = '$baseUrl$endpoint';

        printf('<---url-->$url');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'flag':'get',
            'ClientId': clientId,
            'UserName': userName,
            'EmployeeNumber': empNo,
            'StartDate': startDay,
            'EndDate': endDay,
            'BusObject': 'ATTEND_BUS_Attendance_Events_Overview',
            'RequestComingFrom': 'Mobile',
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
          printf('<----success-getting-event-list---->');

          final Map<String, dynamic> outerJson = jsonDecode(response.data);
          final model = TimeEventModel.fromJson(outerJson);

          if (model.employeeList.isNotEmpty) {
            employeeList.value = model.employeeList;
          }

          printf(
            '<---employeeList--->${model.employeeList.length}--->${employeeList.value.length}',
          );

          for (final emp in model.employeeList) {
            printf('Employee: ${emp.id} - ${emp.value}');
          }
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
                  "Do you want to delete this Attendance Event?",
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
