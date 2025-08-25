import 'dart:convert';
import 'package:crysprsys/model/dashboard/dashboard_report_model.dart';
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

class DashboardReportController extends GetxController {
  final TokenRepository authRepository;

  DashboardReportController({required this.authRepository});

  final box = GetStorage();

  var clientId = '1';
  var userName = 'Call';

  var tileId = '1';

  var employees = <Map<String, dynamic>>[].obs; // resultJson
  var reportFields = <String>[].obs; // ReportFields

  var filteredEmployees = <Map<String, dynamic>>[].obs; // search results
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--DashboardReportController----->');
    tileId = Get.arguments['tileId'] ?? '1';
    printf('<------tile-id----->$tileId');
    loadSavedCredentials();
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
    fetchDashboardReport(
      clientId: clientId,
      userName: userName,
      tileId: tileId,
    );
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmployees.assignAll(employees);
    } else {
      filteredEmployees.assignAll(
        employees.where((item) {
          // search across all fields
          return item.values.any(
            (val) => val.toString().toLowerCase().contains(query.toLowerCase()),
          );
        }).toList(),
      );
    }
  }

  Future<void> fetchDashboardReport({
    required String clientId,
    required String userName,
    required String tileId,
  }) async {
    final report = await getDashboardReportDynamic(
      clientId: clientId,
      userName: userName,
      tileId: tileId,
    );

    if (report != null) {
      employees.assignAll(report.resultJson);
      filteredEmployees.assignAll(report.resultJson);
      reportFields.assignAll(report.reportFields);
    } else {
      employees.clear();
      filteredEmployees.clear();
      reportFields.clear();
    }
  }

  Future<DashboardReport?> getDashboardReportDynamic({
    required String clientId,
    required String userName,
    required String tileId,
  }) async {
    final dio = Dio();
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.dashboardReportApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final queryParameters = {
          'DashboardUserTileId': tileId,
          'CPMClientID': clientId,
          'CPMUserName': userName,
          'Type': 'DisplayReport',
        };

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: queryParameters,
        );

        hideProgress();

        printf('<----response---->${response.data}');

        if (response.statusCode == 200 && response.data != null) {
          final Map<String, dynamic> decoded =
              response.data is String
                  ? jsonDecode(response.data)
                  : response.data;

          return DashboardReport.fromJson(decoded);
        }
      } catch (e) {
        printf("Error: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
    return null;
  }
}

class DashboardReport {
  final List<String> reportFields;
  final List<Map<String, dynamic>> resultJson;

  DashboardReport({required this.reportFields, required this.resultJson});

  factory DashboardReport.fromJson(Map<String, dynamic> json) {
    final reportFieldsString =
        json['dBReportFieldsResult']?['ReportFields'] ?? '';

    final resultJsonString =
        json['dBReportFieldsResult']?['resultJson'] ?? '[]';

    return DashboardReport(
      reportFields: reportFieldsString.toString().split(','),
      resultJson: List<Map<String, dynamic>>.from(jsonDecode(resultJsonString)),
    );
  }
}
