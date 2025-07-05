import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/approval_list_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:convert';

import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';

class CheckInOutApproveController extends GetxController {
  final TokenRepository authRepository;

  CheckInOutApproveController({required this.authRepository});

  final box = GetStorage();
  String firstDay = '';
  String lastDay = '';

  var clientId = '1';
  var userName = 'Call';

  RxList<Attendance> approvalList = <Attendance>[].obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--CheckInOutApproveController----->');

    loadSavedCredentials();
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

    getApprovalListApi(
      clientId: clientId,
      userName: userName,
      empNo: '',
      startDay: firstDay,
      endDay: lastDay,
    );
  }

  Future<void> getApprovalListApi({
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
    const String endpoint = AppConstants.approvalListApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final url = '$baseUrl$endpoint';
        printf('<---url-->$url');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientId': clientId,
            'userName': userName,
            'EmployeeNumber': empNo,
            'StartDate': firstDay,
            'EndDate': endDay,
          },
        );

        printf('<----response---->$response');

        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        final Map<String, dynamic> serviceStatus = jsonDecode(
          outerJson['ServiceStatus'],
        );

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        if (messageCode == "200") {
          final Map<String, dynamic> outerJson = jsonDecode(response.data);
          final model = AttendanceResponse.fromJson(outerJson);
          approvalList.value = model.attendanceList;
          printf('<--loaded approvals--> ${approvalList.length}');
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
