
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/leave_quota_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../model/dashboard/delete_message_model.dart';

class LeaveQuotaController extends GetxController {
  final TokenRepository authRepository;

  LeaveQuotaController({required this.authRepository});

  final box = GetStorage();

  RxList<LeaveQuotaItem> employeesLeavesList = <LeaveQuotaItem>[].obs;
  RxList<DropdownItem> yearList = <DropdownItem>[].obs;
  RxList<DropdownItem> employeeList = <DropdownItem>[].obs;

  final RxString selectedYear = ''.obs;
  final RxString selectedEmp = ''.obs;

  String firstDay = '';
  String lastDay = '';


  var clientId = '1';
  var userName = 'Call';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--LeaveQuotaController----->');
    loadSavedCredentials();
    //getCurrentLocation();
    DateTime now = DateTime.now();

    getFirstAndLastDay(now.year, now.month, true);
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

  void getFirstAndLastDay(int year, int month, bool isRefresh) {
    getLeaveQuotaListApi(
      isRefresh,
      clientId: clientId,
      userName: userName,
      empNo: '',
    );
  }
  void getList() {
    getLeaveQuotaListApi(
      false,
      clientId: clientId,
      userName: userName,
      empNo: '',
    );
  }
  void onYearOrMonthChanged(String year, String monthName) {
    final int yearInt = int.parse(year);
    getFirstAndLastDay(yearInt, 0, false);
  }



  Future<void> getLeaveQuotaListApi(    isRefresh, {
    required String clientId,
    required String userName,
    required String empNo,
  }) async {


    final dio = Dio();
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.leaveRequestGetLeaveQuotaApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'EmployeeNo': empNo,
            'Year': '2025',
          },
        );

        printf('<----response---->${response.data}');

        // ✅ FIXED HERE: don't decode again
        final Map<String, dynamic> outerJson = response.data;

        printf('<----success-getting-event-list---->');

        final model = LeaveQuotaModel.fromJson(outerJson);

        employeesLeavesList.value = model.leaveQuotaList;

        printf('<---leaveList--->${employeeList.value.length}');

        if (isRefresh) {
          if (model.yearList.isNotEmpty) {
            yearList.value = model.yearList;
            selectedYear.value = model.yearList.last.value; // Optional
          }
          if (model.employeesList.isNotEmpty) {
            employeeList.value = model.employeesList;
            selectedEmp.value = model.employeesList.first.value;
          }
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
    }
  }


  Future<void> deleteLeaveApi({
    required String clientId,
    required String userName,
    required String deleteId,
  }) async {
    printf('<--clientId-$clientId--userName-->$userName--eventId-->$deleteId');

    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.deleteLeaveRequestApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'LeaveID': deleteId,
            'BusObjCode': "LM_LR_BUS_NT",
            'DeleteFlag': "Delete",
          },
        );

        printf('<----response---->$response');

        if (response.statusCode == 200) {
          final Map<String, dynamic> outerJson = response.data;
          final model = DeleteMessageModel.fromJson(outerJson);

          final messageText = model.messageText;
          printf('<----messageText---->$messageText');
          dropDownBannerSuccess(messageText!);
          getLeaveQuotaListApi(
            true,
            clientId: clientId,
            userName: userName,
            empNo: '',
          );
        } else {
          dropDownBannerSuccess('Failed to delete.');
          hideProgress();
        }
      } catch (e) {
        printf("Exception: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  void showDeleteEventDialog(String id) {
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
                  "Do you want to delete this Leave ?",
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
                        deleteLeaveApi(
                          clientId: clientId,
                          userName: userName,
                          deleteId: id,
                        );
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
