import 'dart:convert';
import 'dart:developer';

import 'package:crysprsys/app_assistant.dart';
import 'package:crysprsys/controllers/dashboard/dashboard_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/justification_model.dart';
import 'package:crysprsys/model/dashboard/user_time_zone_model.dart';
import 'package:crysprsys/model/justification/justification_drop_down.dart';
import 'package:crysprsys/model/justification/justification_validation.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio_;
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class JustificationAddController extends GetxController {
  final TokenRepository authRepository;

  JustificationAddController({required this.authRepository});

  final box = GetStorage();
  var clientId = '1';
  var userName = '';

  RxList<AuthEmployee> personalNumberList = <AuthEmployee>[].obs;
  RxList<PartnerType> partnerTypeList = <PartnerType>[].obs;
  RxList<ViolationTypeData> violationTypeDataList = <ViolationTypeData>[].obs;

  late Rx<PartnerType?> selectedPartnerType = Rx<PartnerType?>(null);
  Rx<AuthEmployee?> selectedPersonalNumber = Rx<AuthEmployee?>(null);
  Rx<ViolationTypeData?> selectedViolationType = Rx<ViolationTypeData?>(null);
  RxInt selectedRequestType = 0.obs; // default selected: 'Personal'

  TextEditingController textJustificationNo = TextEditingController();
  TextEditingController textStatus = TextEditingController();
  TextEditingController textPendingWith = TextEditingController();
  TextEditingController textJustificationReason = TextEditingController();

  TextEditingController textTimeIn = TextEditingController();
  TextEditingController textTimeOut = TextEditingController();

  TextEditingController textViolationDate = TextEditingController();

  final Map<int, String> requestTypeMap = {0: 'Personal', 1: 'Official'};

  RxBool isShowTimeOut = false.obs;
  RxBool isShowTimeIn = true.obs;
  RxString defaultTime = ''.obs;

  RxString defaultDate = ''.obs;
  RxString selectedInDate = ''.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final dateFormat = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('HH:mm:ss');

  var role = '';
  var roleCode = '';
  var userId = '';

  var from = AppConstants.add;
  RxString title = 'Justification'.obs;

  var notificationStatus = '';
  var notificationBusObject = '';
  var notificationObjectNo = '';
  var notificationId = '';

  RxBool isFromNotification = false.obs;

  var textSaved = 'Saved';
  var textSubmitted =  'Submitted';

  late final UserSettingsModel userSettingsTimeZone;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--JustificationAddController----->');
    loadSavedCredentials();

    final DateTime fullDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    defaultTime.value = timeFormat.format(fullDateTime);

    textTimeIn.text = ''; //defaultTime.value;
    textTimeOut.text = ''; // defaultTime.value;

    textViolationDate.text = dateFormat.format(selectedDate.value);

    textJustificationNo.text = '0';

    try {
      from = Get.arguments['from'] ?? AppConstants.add;
      if (from == AppConstants.edit) {
        JustificationItem emp = Get.arguments['emp'];

        textJustificationNo.text = emp.justid.toString();

        printf('violationType-->${emp.partnerType} status-->${emp.status}');
        printf('empid-->${emp.employeeID} empName-->${emp.employeeName}');

        getDropDownListApi(clientId: clientId, userName: userName).whenComplete(
          () {
            textViolationDate.text = emp.date;
            textStatus.text = emp.status;
            textTimeIn.text = emp.timeIn;
            selectedPartnerType.value = partnerTypeList.firstWhere(
              (element) => element.value == emp.partnerType,
            );
            selectedPersonalNumber.value = personalNumberList.firstWhere(
              (element) => element.id == emp.employeeID,
            );
            selectedViolationType.value = violationTypeDataList.firstWhere(
              (element) => element.value == emp.violationType,
            );
            textJustificationReason.text = emp.justifyComments;
          },
        );
      } else if (from == AppConstants.view) {
        JustificationItem emp = Get.arguments['emp'];

        textJustificationNo.text = emp.justid.toString();

        getDropDownListApi(clientId: clientId, userName: userName).whenComplete(
          () {
            textViolationDate.text = emp.date;
            textStatus.text = emp.status;

            textTimeIn.text = emp.timeIn;

            selectedPartnerType.value = partnerTypeList.firstWhere(
              (element) => element.value == emp.partnerType,
            );

            selectedPersonalNumber.value = personalNumberList.firstWhere(
              (element) => element.id == emp.employeeID,
            );

            selectedViolationType.value = violationTypeDataList.firstWhere(
              (element) => element.value == emp.violationType,
            );

            textJustificationReason.text = emp.justifyComments;
          },
        );
      } else if (from == 'Notification') {
        isFromNotification.value = true;
        final dashboardController = Get.find<DashboardController>();
        title.value = 'Decision Justification';
        textJustificationNo.text = Get.arguments['objectNo'];
        notificationId = Get.arguments['notificationNo'];
        notificationStatus = Get.arguments['status'];
        notificationObjectNo = Get.arguments['objectNo'];
        notificationBusObject = Get.arguments['businessObject'];
        printf('<--status :$notificationStatus');
        printf('<--busObj :$notificationBusObject');
        printf('<--ObjNo :$notificationObjectNo');
        printf('<---notificationNo :$notificationId}');

        // getDropDownListApi(clientId: clientId, userName: userName).whenComplete(
        //   () {
        //     textStatus.text = Get.arguments['status'];
        //
        //     try {
        //       var dateTime = Get.arguments['date'];
        //       List<String> parts = dateTime.split(" ");
        //       String date = parts[0];
        //       String time = parts[1].substring(0, 5);
        //
        //       textViolationDate.text = date;
        //       textTimeIn.text = time;
        //     } catch (e) {
        //       printf('exe--notification->$e');
        //     }
        //
        //     viewNotification(
        //       clientId: clientId,
        //       userName: userName,
        //       notificationNo: notificationId,
        //     ).whenComplete(() {
        //       dashboardController.getNotificationCount(
        //         clientId: clientId,
        //         userName: userName,
        //       );
        //     });
        //   },
        // );

        DateTime now = DateTime.now();
        getFirstAndLastDay(now.year, now.month, true).whenComplete(
          () async {
            printf('completed-------------->');
            await Future.delayed(const Duration(seconds: 2));
            printf('delay finished-------------->');
            viewNotification(
              clientId: clientId,
              userName: userName,
              notificationNo: notificationId,
            ).whenComplete(() {
              dashboardController.getNotificationCount(
                clientId: clientId,
                userName: userName,
              );
            });
          },
        );
      } else {
        title.value = 'Create Justification';
        getUserTimeZoneApi(clientId: clientId, userName: userName).whenComplete(
          () {
            getDropDownListApi(clientId: clientId, userName: userName);
          },
        );
      }

      printf('<---from---->$from');
    } catch (e) {
      printf('exe-from-->$e');
    }
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

    try {
      role = box.read(AppConstants.prefRole);
      roleCode = box.read(AppConstants.prefRoleCode);
      userId = box.read(AppConstants.prefUserId);
      printf('role->$role--roleCode-->$roleCode--userId-->$userId');
    } catch (e) {
      printf('exe-load-save-data-->$e');
    }

    printf('<---userName-->$userName---clientId--->$clientId');
  }

  void changeType(ViolationTypeData type) {
    printf('<--selected-type-->${type.id} ${type.value}');
    if (type.id == '1' || type.id == '2' || type.id == '4') {
      isShowTimeOut.value = false;
    } else {
      isShowTimeOut.value = true;
    }

    if (type.value == 'Absent') {
      isShowTimeIn.value = false;
      textTimeIn.text = '';
    } else {
      isShowTimeIn.value = true;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: today, //DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedInDate.value =
          picked.toUtc().toIso8601String(); // "2025-02-06T05:00:00.000Z"
      printf('Selected UTC Date: $selectedInDate');

      // selectedDate.value = picked;
      // defaultDate.value = dateFormat.format(picked);

      textViolationDate.text = dateFormat.format(picked);
    }
  }

  Future<void> selectTime(BuildContext context, String from) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );

    if (picked != null && picked != selectedTime.value) {
      final now = DateTime.now();

      final pickedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (from == 'in') {
        textTimeIn.text = timeFormat.format(pickedDateTime);
      } else {
        textTimeOut.text = timeFormat.format(pickedDateTime);
      }
    }
  }

  Future<void> getUserTimeZoneApi({
    required String clientId,
    required String userName,
  }) async {
    printf('<--getUserTimeZoneApi-clientId-$clientId--userName-->$userName');

    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getUserTimeZoneApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {'CPMClientID': clientId, 'CPMUserName': userName},
        );

        printf('<----response---->$response');

        final List<dynamic> jsonList = jsonDecode(response.toString());
        userSettingsTimeZone = UserSettingsModel.fromJson(jsonList.first);

        printf('time-zone-->${userSettingsTimeZone.userTimeZone}');

        hideProgress();
      } catch (e) {
        printf("Exception: $e");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> viewNotification({
    required String clientId,
    required String userName,
    required String notificationNo,
  }) async {
    printf('<--viewNotification-clientId-$clientId--userName-->$userName');

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.viewNotificationApi;

    final dio = Dio();

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final uri = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'NotificationNo': notificationNo,
            'Date': '',
          },
        );

        printf('Full URL: $uri');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'NotificationNo': notificationNo,
            'Date': '',
          },
        );

        hideProgress();
        printf('<----response---->${response.data}');
      } catch (e, st) {
        printf("Exception: $e");
        printf("StackTrace: $st");
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> getDropDownListApi({
    required String clientId,
    required String userName,
  }) async {
    printf('<--clientId-$clientId--userName-->$userName');

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getJustificationDropDownListApi;

    final dio = Dio();

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final uri = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: {
            'BusObjCode': 'ATTEND_BUS_New_Justification',
            'SMode': from == AppConstants.edit ? 'Edit' : 'Create',
            'CPMClientID': clientId,
            'CPMUserName': userName,
          },
        );

        printf('Full URL: $uri');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'BusObjCode': 'ATTEND_BUS_New_Justification',
            'SMode': 'Create',
            'CPMClientID': clientId,
            'CPMUserName': userName,
          },
        );

        hideProgress();
        printf('<----response---->${response.data}');

        if (response.statusCode == 200 && response.data != null) {
          dynamic responseBody;
          if (response.data is String) {
            responseBody = jsonDecode(response.data);
          } else {
            responseBody = response.data;
          }

          final parsed = JustificationCreateData.fromJson(responseBody);

          personalNumberList.assignAll(parsed.authEmployeesList);
          partnerTypeList.assignAll(parsed.partnerTypeList);
          violationTypeDataList.assignAll(parsed.violationTypeDataList);

          printf("personalNumberList : ${personalNumberList.length}");
          printf("partnerTypeList : ${partnerTypeList.length}");
          printf("violationTypeDataList : ${violationTypeDataList.length}");

          for (final item in violationTypeDataList) {
            printf(
              'violationTypeDataList ID: ${item.id}, Value: ${item.value}',
            );
          }

          if (partnerTypeList.isNotEmpty) {
            selectedPartnerType.value = partnerTypeList.first;
          }

          if (personalNumberList.isNotEmpty) {
            selectedPersonalNumber.value = personalNumberList.first;
          }

          violationTypeDataList.assignAll(parsed.violationTypeDataList);
          if (violationTypeDataList.isNotEmpty) {
            selectedViolationType.value = violationTypeDataList.first;
          }
        } else {
          Utility.showToastMessage('Invalid response from server.');
        }
      } catch (e, st) {
        printf("Exception: $e");
        printf("StackTrace: $st");
        Utility.showToastMessage('Failed to fetch dropdown data.');
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> buttonCreateJustification(from) async {
    if (textJustificationNo.text.isEmpty) {
      dropDownBannerError('Please enter justification no');
    } else if (textJustificationReason.text.isEmpty) {
      dropDownBannerError('Please add justification reason ');
    } else {
      printf('<----create-justification--->');

      var validationVariable = {
        "BusObjCode": "ATTEND_BUS_New_Justification",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": '',
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? "SAVE" : "SUBMIT",
        "ScreenMode": 'Create',
        "UserID": userId,
        "RoleID": clientId,
        "Notification_ID": '',
      };

      printf(
        'Validation Variable payload :\n${jsonEncode(validationVariable)}',
      );

      var justifyList = {
        "UserName": userName,
        "JUSTID": textJustificationNo.text.trim() == "0" ? "" : textJustificationNo.text.trim(),
        "PartnerType": selectedPartnerType.value?.id.toString(),
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "Date": DateTime.parse("${textViolationDate.text.trim()} ${DateFormat('HH:mm:ss').format(DateTime.now())}").toUtc().toIso8601String(),
        "InTime": textTimeIn.text,
        "OutTime": textTimeOut.text,
        "Violationtype": selectedViolationType.value?.id.toString(),
        "Status": from == 'save' ? textSaved : textSubmitted,
        //textStatus.text.trim(),
        "JustifyComments": textJustificationReason.text.trim(),
        "RequestType": selectedRequestType.value.toString(),
      };

      printf('Justification List payload:\n${jsonEncode(justifyList)}');

      var approvalData = {
        "Status": from == 'save' ? textSaved : textSubmitted, //"Saved",
        "AppCode": "ATTEND",
        "BusObjectDesc": "Attendance Justification",
        "MemberStatus": "",
        "SaveOrSubmit": from == 'save' ? "SAVE" : "SUBMIT", //"SAVE",
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "baseUrl": "https://eportal.crisprsys.net",
        "Comment": "",
        "UserAction": from == 'save' ? "SAVE" : "SUBMIT", //"SAVE",
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf('<--createJustification-clientId-$clientId--userName-->$userName');

      const String baseUrl = AppConstants.baseUrl;
      const String endpoint = AppConstants.validationForJustification;

      if (await InternetConnection().hasInternetAccess) {
        showProgress();
        final url =
            '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
            'ValidationVariables=${jsonEncode(validationVariable)}&'
            'JustifyObjectJson=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

        printf('<---url-->$url');

        final dio = dio_.Dio();
        final response = await dio.get(url);
        printf('<---response-for-validation-->$response');

        printf('Response runtimeType: ${response.data.runtimeType}');
        printf('Raw response: ${response.data}');

        final Map<String, dynamic> data = response.data;

        final String message = data['ActualResponse'] ?? 'No message provided';

        printf('<---message--->$message');

        if (message == 'Success') {
          final data = response.data;

          final teamMembersJson = data['TeamMembersList'] as List<dynamic>;

          final List<TeamMember> teamMembersList =
              teamMembersJson.map((e) => TeamMember.fromJson(e)).toList();

          printf('<--Parsed Members Count--> ${teamMembersList.length}');

          try {
            printf('<--call-add-justification---->');

            const String baseUrl =
                AppConstants.baseUrl; // Replace with your base URL
            const String endpoint = AppConstants.createJustificationApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            // Log all URL components before API call
            printf('\n========== CREATE JUSTIFICATION API REQUEST ==========');
            printf('Base URL: $baseUrl$endpoint');
            printf('CPMClientID: $clientId');
            printf('CPMUserName: $userName');
            printf('BusObjCode: ATTEND_BUS_New_Justification');
            
            printf('\n--- JustificationList (Pretty Print) ---');
            final justifyListPretty = JsonEncoder.withIndent('  ').convert(justifyList);
            printf(justifyListPretty);
            
            printf('\n--- JustificationList (URL Encoded) ---');
            printf(jsonEncode(justifyList));
            
            printf('\n--- TeamMembersJsonData Count: ${teamMembersList.length} ---');
            printf('TeamMembersJsonData (Pretty Print):');
            for (int i = 0; i < teamMembersList.length; i++) {
              printf('Member $i:');
              final memberPretty = JsonEncoder.withIndent('  ').convert(teamMembersList[i].toJson());
              printf(memberPretty);
            }
            
            printf('\n--- TeamMembersJsonData (Full JSON) ---');
            final teamMembersFull = JsonEncoder.withIndent('  ').convert(
              teamMembersList.map((e) => e.toJson()).toList(),
            );
            printf(teamMembersFull);
            
            printf('\n--- TeamMembersJsonData (URL Encoded - First 500 chars) ---');
            printf(teamMembersEncoded.substring(0, teamMembersEncoded.length > 500 ? 500 : teamMembersEncoded.length));
            if (teamMembersEncoded.length > 500) {
              printf('... (${teamMembersEncoded.length - 500} more characters)');
            }
            
            printf('\n--- ApprovalData (Pretty Print) ---');
            final approvalDataPretty = JsonEncoder.withIndent('  ').convert(approvalData);
            printf(approvalDataPretty);
            
            printf('\n--- ApprovalData (URL Encoded) ---');
            printf(jsonEncode(approvalData));
            
            printf('\n======================================================\n');

            final urlForAdd =
                '$baseUrl$endpoint?CPMClientID=$clientId&CPMUserName=$userName&'
                'BusObjCode=ATTEND_BUS_New_Justification&'
                'JustificationList=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}'; //; //&FilePath=$encodedPath';

            printf('<---Final URL Length: ${urlForAdd.length} characters--->');
            printf('URL (first 1000 chars): ${urlForAdd.substring(0, urlForAdd.length > 1000 ? 1000 : urlForAdd.length)}...');

            final dio = dio_.Dio();
            final res = await dio.get(urlForAdd);

            printf('Response runtimeType: ${res.data.runtimeType}');
            printf('Raw response: ${res.data}');

            final Map<String, dynamic> data = jsonDecode(res.data);

            final String message = data['Message'] ?? 'No message provided';

            Get.back(result: true);
            dropDownBannerSuccess(message);

            hideProgress();
          } catch (e) {
            printf('exe-->$e');
            hideProgress();
          }
        } else {
          final data = response.data;
          final messageText =
              data['ValidationResponse']?['MessageText'] ??
              AppConstants.somethingWentWrong;
          dropDownBannerError(messageText);
        }
        hideProgress();
      } else {
        Utility.showToastMessage(AppConstants.internetConnectionError);
      }
    }
  }

  Future<void> buttonUpdateJustification(from) async {
    if (textJustificationNo.text.isEmpty) {
      dropDownBannerError('Please enter justification no');
    } else if (textJustificationReason.text.isEmpty) {
      dropDownBannerError('Please add justification reason ');
    } else {
      printf('<----create-justification--->');

      var validationVariable = {
        "BusObjCode": "ATTEND_BUS_New_Justification",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": '',
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? "SAVE" : "SUBMIT",
        "ScreenMode": 'Create',
        "UserID": userId,
        "RoleID": clientId,
        "Notification_ID": '',
      };

      printf(
        'Validation Variable payload :\n${jsonEncode(validationVariable)}',
      );

      var justifyList = {
        "UserName": selectedPersonalNumber.value?.id.toString(),
        "JUSTID": textJustificationNo.text.trim() == "0" ? "" : textJustificationNo.text.trim(),
        "PartnerType": selectedPartnerType.value?.id.toString(),
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "Date": () {
          try {
            // Try to parse the date in yyyy-MM-dd format first
            final dateStr = textViolationDate.text.trim();
            final timeStr = DateFormat('HH:mm:ss').format(DateTime.now());
            final combinedStr = "$dateStr $timeStr";
            return DateTime.parse(combinedStr).toUtc().toIso8601String();
          } catch (e) {
            printf('Error parsing date: $e, trying dd/MM/yyyy format');
            // Fallback: try parsing with dd/MM/yyyy format
            try {
              final dateStr = textViolationDate.text.trim();
              final parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);
              final combinedDateTime = DateTime(
                parsedDate.year,
                parsedDate.month,
                parsedDate.day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second,
              );
              return combinedDateTime.toUtc().toIso8601String();
            } catch (e2) {
              printf('Error parsing date with fallback: $e2');
              return DateTime.now().toUtc().toIso8601String();
            }
          }
        }(),
        "InTime": textTimeIn.text,
        "OutTime": textTimeOut.text,
        "Violationtype": selectedViolationType.value?.id.toString(),
        "Status": from == 'save' ? textSaved : textSubmitted,
        //textStatus.text.trim(),
        "JustifyComments": textJustificationReason.text.trim(),
        "RequestType": selectedRequestType.value.toString(),
      };

      printf('Justification List payload:\n${jsonEncode(justifyList)}');

      var approvalData = {
        "Status": from == 'save' ? textSaved : textSubmitted, //"Saved",
        "AppCode": "ATTEND",
        "BusObjectDesc": "Attendance Justification",
        "MemberStatus": "",
        "SaveOrSubmit": from == 'save' ? "SAVE" : "SUBMIT", //"SAVE",
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": clientId,
        "baseUrl": "https://eportal.crisprsys.net",
        "Comment": "",
        "NotificationNo": "",
        "UserAction": from == 'save' ? "SAVE" : "SUBMIT", //"SAVE",
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf('<--updateJustification-clientId-$clientId--userName-->$userName');

      const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
      const String endpoint = AppConstants.validationForJustification;

      if (await InternetConnection().hasInternetAccess) {
        showProgress();
        final url =
            '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
            'ValidationVariables=${jsonEncode(validationVariable)}&'
            'JustifyObjectJson=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

        printf('<---url-->$url');

        final dio = dio_.Dio();
        final response = await dio.get(url);
        printf('<---response-for-validation-->$response');

        printf('Response runtimeType: ${response.data.runtimeType}');
        printf('Raw response: ${response.data}');

        final Map<String, dynamic> data = response.data;

        final String message = data['ActualResponse'] ?? 'No message provided';

        printf('<---message--->$message');

        if (message == 'Success') {
          final data = response.data;

          final teamMembersJson = data['TeamMembersList'] as List<dynamic>;

          final List<TeamMember> teamMembersList =
              teamMembersJson.map((e) => TeamMember.fromJson(e)).toList();

          printf('<--Parsed Members Count--> ${teamMembersList.length}');

          try {
            printf('<--call-update-justification---->');

            const String baseUrl =
                AppConstants.baseUrl; // Replace with your base URL
            const String endpoint = AppConstants.updateJustificationApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            // Log all URL components before API call
            printf('\n========== UPDATE JUSTIFICATION API REQUEST ==========');
            printf('Base URL: $baseUrl$endpoint');
            printf('CPMClientID: $clientId');
            printf('CPMUserName: $userName');
            printf('BusObjCode: ATTEND_BUS_New_Justification');
            
            printf('\n--- JustificationList (Pretty Print) ---');
            final justifyListPretty = JsonEncoder.withIndent('  ').convert(justifyList);
            printf(justifyListPretty);
            
            printf('\n--- JustificationList (URL Encoded) ---');
            printf(jsonEncode(justifyList));
            
            printf('\n--- TeamMembersJsonData Count: ${teamMembersList.length} ---');
            printf('TeamMembersJsonData (Pretty Print):');
            for (int i = 0; i < teamMembersList.length; i++) {
              printf('Member $i:');
              final memberPretty = JsonEncoder.withIndent('  ').convert(teamMembersList[i].toJson());
              printf(memberPretty);
            }
            
            printf('\n--- TeamMembersJsonData (Full JSON) ---');
            final teamMembersFull = JsonEncoder.withIndent('  ').convert(
              teamMembersList.map((e) => e.toJson()).toList(),
            );
            printf(teamMembersFull);
            
            printf('\n--- TeamMembersJsonData (URL Encoded - First 500 chars) ---');
            printf(teamMembersEncoded.substring(0, teamMembersEncoded.length > 500 ? 500 : teamMembersEncoded.length));
            if (teamMembersEncoded.length > 500) {
              printf('... (${teamMembersEncoded.length - 500} more characters)');
            }
            
            printf('\n--- ApprovalData (Pretty Print) ---');
            final approvalDataPretty = JsonEncoder.withIndent('  ').convert(approvalData);
            printf(approvalDataPretty);
            
            printf('\n--- ApprovalData (URL Encoded) ---');
            printf(jsonEncode(approvalData));
            
            printf('\n======================================================\n');

            final urlForAdd =
                '$baseUrl$endpoint?CPMClientID=$clientId&CPMUserName=$userName&'
                'BusObjCode=ATTEND_BUS_New_Justification&'
                'JustificationList=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}'; //; //&FilePath=$encodedPath';

            printf('<---Final URL Length: ${urlForAdd.length} characters--->');
            printf('URL (first 1000 chars): ${urlForAdd.substring(0, urlForAdd.length > 1000 ? 1000 : urlForAdd.length)}...');

            final dio = dio_.Dio();
            final res = await dio.get(urlForAdd);

            printf('Response runtimeType: ${res.data.runtimeType}');
            printf('Raw response: ${res.data}');

            final Map<String, dynamic> data = jsonDecode(res.data);

            final String message = data['Message'] ?? 'No message provided';

            Get.back(result: true);
            dropDownBannerSuccess(message);

            hideProgress();
          } catch (e) {
            printf('exe-->$e');
            hideProgress();
          }
        } else {
          final data = response.data;
          final messageText =
              data['ValidationResponse']?['MessageText'] ??
              AppConstants.somethingWentWrong;
          dropDownBannerError(messageText);
        }
        hideProgress();
      } else {
        Utility.showToastMessage(AppConstants.internetConnectionError);
      }
    }
  }

  Future<void> buttonApproveRejectNotification(type) async {
    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.approveNotification;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final uri = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'SourceBusObj': 'CRIS_BUS_NOTIF_DB_MyAppr',
            'TargetBusObj': notificationBusObject,
            'Action': '5',
            'Notification_Status': notificationStatus,
            'Notification_Type': type, //'Approval',
            'NotificationID': notificationId,
            'TargetBusinessObject': 'ATTEND_BUS_New_Justification',
            'ObjectNo': notificationObjectNo,
          },
        );

        printf('<---Final URL--->${uri.toString()}');

        final dio = dio_.Dio();
        final response = await dio.getUri(uri);

        printf('<---response-for-validation-->$response');
        printf('Response runtimeType: ${response.data.runtimeType}');
        printf('Raw response: ${response.data}');

        Map<String, dynamic> data;
        if (response.data is Map<String, dynamic>) {
          data = response.data;
        } else if (response.data is String) {
          data = jsonDecode(response.data);
        } else {
          printf('Unexpected response format');
          return;
        }

        final String message =
            data['ActualResponse']?.toString() ?? 'No message provided';
        printf('<---message--->$message');
      } catch (e, stack) {
        printf('Error in buttonApproveNotification: $e');
        printf(stack.toString());
        Utility.showToastMessage('Something went wrong. Please try again.');
      } finally {
        hideProgress();
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> buttonApproveReject(type) async {
    if (textJustificationNo.text.isEmpty) {
      dropDownBannerError('Please enter justification no');
    } else if (textJustificationReason.text.isEmpty) {
      dropDownBannerError('Please add justification reason ');
    } else {
      printf('<----create-justification--->');

      var validationVariable = {
        "BusObjCode": "ATTEND_BUS_New_Justification",
        "ControlID": '5',
        "ObjectNo": notificationObjectNo,
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": type,
        "ScreenMode": 'Create',
        "UserID": userId,
        "RoleID": clientId,
        "Notification_ID": notificationId,
      };

      printf(
        'Validation Variable payload :\n${jsonEncode(validationVariable)}',
      );

      var justifyList = {
        "UserName": userName,
        "JUSTID": textJustificationNo.text.trim(),
        "PartnerType": selectedPartnerType.value?.id.toString(),
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "Date": textViolationDate.text.trim(),
        "InTime": textTimeIn.text,
        "OutTime": textTimeOut.text,
        "Violationtype": selectedViolationType.value?.id.toString(),
        "Status": textStatus.text.trim(),
        "JustifyComments": textJustificationReason.text.trim(),
        "RequestType": selectedRequestType.value,
      };

      printf('Justification List payload:\n${jsonEncode(justifyList)}');

      var approvalData = {
        "Status": textStatus.text.trim(),
        "AppCode": "ATTEND",
        "BusObjectDesc": "Attendance Justification",
        "MemberStatus": "",
        "SaveOrSubmit": type,
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "baseUrl": "https://eportal.crisprsys.net",
        "Comment": "",
        "UserAction": type,
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf('<--createJustification-clientId-$clientId--userName-->$userName');

      const String baseUrl = AppConstants.baseUrl;
      const String endpoint = AppConstants.validationForJustification;

      if (await InternetConnection().hasInternetAccess) {
        showProgress();
        final url =
            '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
            'ValidationVariables=${jsonEncode(validationVariable)}&'
            'JustifyObjectJson=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

        printf('<---url-->$url');

        final dio = dio_.Dio();
        final response = await dio.get(url);
        printf('<---response-for-validation-->$response');

        printf('Response runtimeType: ${response.data.runtimeType}');
        printf('Raw response: ${response.data}');

        final Map<String, dynamic> data = response.data;

        final String message = data['ActualResponse'] ?? 'No message provided';

        printf('<---message--->$message');

        if (message == 'Success') {
          final data = response.data;

          final teamMembersJson = data['TeamMembersList'] as List<dynamic>;

          final List<TeamMember> teamMembersList =
              teamMembersJson.map((e) => TeamMember.fromJson(e)).toList();

          printf('<--Parsed Members Count--> ${teamMembersList.length}');

          try {
            printf('<--call-approve-reject-justification---->');

            const String baseUrl =
                AppConstants.baseUrl; // Replace with your base URL
            const String endpoint = AppConstants.updateJustificationApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            // Log all URL components before API call
            printf('\n========== APPROVE/REJECT JUSTIFICATION API REQUEST ==========');
            printf('Base URL: $baseUrl$endpoint');
            printf('CPMClientID: $clientId');
            printf('CPMUserName: $userName');
            printf('BusObjCode: ATTEND_BUS_New_Justification');
            printf('Action Type: $type');
            
            printf('\n--- JustificationList (Pretty Print) ---');
            final justifyListPretty = JsonEncoder.withIndent('  ').convert(justifyList);
            printf(justifyListPretty);
            
            printf('\n--- JustificationList (URL Encoded) ---');
            printf(jsonEncode(justifyList));
            
            printf('\n--- TeamMembersJsonData Count: ${teamMembersList.length} ---');
            printf('TeamMembersJsonData (Pretty Print):');
            for (int i = 0; i < teamMembersList.length; i++) {
              printf('Member $i:');
              final memberPretty = JsonEncoder.withIndent('  ').convert(teamMembersList[i].toJson());
              printf(memberPretty);
            }
            
            printf('\n--- TeamMembersJsonData (Full JSON) ---');
            final teamMembersFull = JsonEncoder.withIndent('  ').convert(
              teamMembersList.map((e) => e.toJson()).toList(),
            );
            printf(teamMembersFull);
            
            printf('\n--- TeamMembersJsonData (URL Encoded - First 500 chars) ---');
            printf(teamMembersEncoded.substring(0, teamMembersEncoded.length > 500 ? 500 : teamMembersEncoded.length));
            if (teamMembersEncoded.length > 500) {
              printf('... (${teamMembersEncoded.length - 500} more characters)');
            }
            
            printf('\n--- ApprovalData (Pretty Print) ---');
            final approvalDataPretty = JsonEncoder.withIndent('  ').convert(approvalData);
            printf(approvalDataPretty);
            
            printf('\n--- ApprovalData (URL Encoded) ---');
            printf(jsonEncode(approvalData));
            
            printf('\n======================================================\n');

            final urlForAdd =
                '$baseUrl$endpoint?CPMClientID=$clientId&CPMUserName=$userName&'
                'BusObjCode=ATTEND_BUS_New_Justification&'
                'JustificationList=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}'; //; //&FilePath=$encodedPath';

            printf('<---Final URL Length: ${urlForAdd.length} characters--->');
            printf('URL (first 1000 chars): ${urlForAdd.substring(0, urlForAdd.length > 1000 ? 1000 : urlForAdd.length)}...');

            final dio = dio_.Dio();
            final res = await dio.get(urlForAdd);

            printf('Response runtimeType: ${res.data.runtimeType}');
            printf('Raw response: ${res.data}');

            final Map<String, dynamic> data = jsonDecode(res.data);

            final String message = data['Message'] ?? 'No message provided';

            Get.back(result: true);
            dropDownBannerSuccess(message);

            hideProgress();
          } catch (e) {
            printf('exe-->$e');
            hideProgress();
          }
        } else {
          final data = response.data;
          final messageText =
              data['ValidationResponse']?['MessageText'] ??
              AppConstants.somethingWentWrong;
          dropDownBannerError(messageText);
        }
        hideProgress();
      } else {
        Utility.showToastMessage(AppConstants.internetConnectionError);
      }
    }
  }

  String dateToYMD(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> getFirstAndLastDay(int year, int month, bool isRefresh) async {
    String firstDay = '';
    String lastDay = '';

    DateTime fd = DateTime(year, month, 1);
    DateTime ld = DateTime(year, month + 1, 0);

    firstDay = dateToYMD(fd);
    lastDay = dateToYMD(ld);

    printf("First day: $firstDay");
    printf("Last day: $lastDay");

    getJustificationList(
      isRefresh,
      clientId: clientId,
      userName: userName,
      startDay: firstDay,
      endDay: lastDay,
    );
  }

  Future<void> getJustificationList(
    isRefresh, {
    required String clientId,
    required String userName,
    required String startDay,
    required String endDay,
  }) async {
    printf(
      '<--clientId-$clientId--userName-->$userName--start-day-->$startDay--end-day-->$endDay',
    );
    RxList<JustificationItem> employeeList = <JustificationItem>[].obs;
    final dio = Dio();

    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.getJustDashboardDataApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final url = '$baseUrl$endpoint';

        printf('<---url-->$url');

        final queryParams = {
          'flag': 'get',
          'CPMClientID': clientId,
          'CPMUserName': userName,
          'AccessToken': '',
          'SessionID': '',
          'BusObjCode': 'ATTEND_BUS_Justification',
          'RequestComingFrom': 'Mobile',
          'AttendenceParamters': jsonEncode({
            "StartDate": startDay,
            "EndDate": endDay,
            "UserID": "1",
            "RoleID": "1",
            "ScreenType": "ATTEND_BUS_Justification",
            "DefaultName": "ATTEND_Justification",
          }),
        };

        final uri = Uri.parse(
          '$baseUrl$endpoint',
        ).replace(queryParameters: queryParams);

        printf('<-- Full URL --> ${uri.toString()}');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'flag': 'get',
            'CPMClientID': clientId,
            'CPMUserName': userName,
            'AccessToken': '',
            'SessionID': '',
            'BusObjCode': 'ATTEND_BUS_Justification',
            'RequestComingFrom': 'Mobile',
            'AttendenceParamters': jsonEncode({
              "StartDate": startDay,
              "EndDate": endDay,
              "UserID": "1",
              "RoleID": "1",
              "ScreenType": "ATTEND_BUS_Justification",
              "DefaultName": "ATTEND_Justification",
            }),
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
          employeeList.clear();
          printf('<----success-getting-justification-list---->');

          final Map<String, dynamic> outerJson = jsonDecode(response.data);
          final model = JustificationModel.fromJson(outerJson);

          if (model.justifyResults.justificationList.isNotEmpty) {
            employeeList.value = model.justifyResults.justificationList;
          }

          printf('<----list-of-justification---->${employeeList.length}');

          for (final emp in model.justifyResults.justificationList) {
            if (notificationObjectNo == emp.justid) {
              textJustificationNo.text = emp.justid.toString();

              getDropDownListApi(
                clientId: clientId,
                userName: userName,
              ).whenComplete(() {
                textViolationDate.text = emp.date;
                textStatus.text = emp.status;

                textTimeIn.text = emp.timeIn;

                selectedPartnerType.value = partnerTypeList.firstWhere(
                  (element) => element.value == emp.partnerType,
                );

                selectedPersonalNumber.value = personalNumberList.firstWhere(
                  (element) => element.id == emp.employeeID,
                );

                selectedViolationType.value = violationTypeDataList.firstWhere(
                  (element) => element.value == emp.violationType,
                );

                textJustificationReason.text = emp.justifyComments;
              });
              break;
            }
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
}
