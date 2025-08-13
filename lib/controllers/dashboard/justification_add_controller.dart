import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/justification_model.dart';
import 'package:crysprsys/model/justification/justification_drop_down.dart';
import 'package:crysprsys/model/justification/justification_validation.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio_;
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class JustificationAddController extends GetxController {
  final TokenRepository authRepository;

  JustificationAddController({required this.authRepository});

  final box = GetStorage();
  var clientId = '1';
  var userName = 'Call';

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

  @override
  void onInit() {
    super.onInit();
    printf('<------init--JustificationAddController----->');
    loadSavedCredentials();

    // defaultDate.value = dateFormat.format(selectedDate.value);
    // selectedInDate.value = selectedDate.value.toUtc().toIso8601String();

    // Combine selectedDate and selectedTime to build fullDateTime
    final DateTime fullDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    // Format display time (e.g., 10:30 AM)
    defaultTime.value = timeFormat.format(fullDateTime);

    textTimeIn.text = ''; //defaultTime.value;
    textTimeOut.text = ''; // defaultTime.value;

    textViolationDate.text = dateFormat.format(selectedDate.value);

    textJustificationNo.text = '0';

    try {
      from = Get.arguments['from'] ?? AppConstants.add;
      if (from == AppConstants.edit)
      {
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
          },
        );
      } else {
        getDropDownListApi(clientId: clientId, userName: userName);
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
    printf('<--selected-type-->${type.id}');
    if (type.id == '1' || type.id == '2' || type.id == '4') {
      isShowTimeOut.value = false;
    } else {
      isShowTimeOut.value = true;
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
            'SMode': 'Create',
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

        if (response.statusCode == 200 && response.data != null)
        {
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
    }
    // else if (textStatus.text.isEmpty) {
    //   dropDownBannerError('Please enter status');
    // } else if (textPendingWith.text.isEmpty) {
    //   dropDownBannerError('Please enter pending with');
    // }
    else if (textJustificationReason.text.isEmpty) {
      dropDownBannerError('Please add justification reason ');
    } else {
      printf('<----create-justification--->');

      var validationVariable = {
        "BusObjCode": "ATTEND_BUS_New_Justification",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": '',
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? 'SAVE' : 'SUBMIT',
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
        "Status": "Saved",
        "AppCode": "ATTEND",
        "BusObjectDesc": "Attendance Justification",
        "MemberStatus": "",
        "SaveOrSubmit": "SAVE",
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "baseUrl": "https://eportal.crisprsys.net",
        "Comment": "",
        "UserAction": "SAVE",
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf('<--createJustification-clientId-$clientId--userName-->$userName');

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

        if (message == 'Success')
        {
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

            final urlForAdd =
                '$baseUrl$endpoint?CPMClientID=$clientId&CPMUserName=$userName&'
                'BusObjCode=ATTEND_BUS_New_Justification&'
                'JustificationList=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}'; //; //&FilePath=$encodedPath';

            printf('<---urlForAdd-->$urlForAdd');

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
          dropDownBannerError(AppConstants.somethingWentWrong);
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
    }
    // else if (textStatus.text.isEmpty) {
    //   dropDownBannerError('Please enter status');
    // } else if (textPendingWith.text.isEmpty) {
    //   dropDownBannerError('Please enter pending with');
    // }
    else if (textJustificationReason.text.isEmpty) {
      dropDownBannerError('Please add justification reason ');
    } else {
      printf('<----create-justification--->');

      var validationVariable = {
        "BusObjCode": "ATTEND_BUS_New_Justification",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": '',
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? 'SAVE' : 'SUBMIT',
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
        "Status": "Saved",
        "AppCode": "ATTEND",
        "BusObjectDesc": "Attendance Justification",
        "MemberStatus": "",
        "SaveOrSubmit": "SAVE",
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": selectedPersonalNumber.value?.id.toString(),
        "baseUrl": "https://eportal.crisprsys.net",
        "Comment": "",
        "UserAction": "SAVE",
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
            printf('<--call-add-justification---->');

            const String baseUrl =
                AppConstants.baseUrl; // Replace with your base URL
            const String endpoint = AppConstants.updateJustificationApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            final urlForAdd =
                '$baseUrl$endpoint?CPMClientID=$clientId&CPMUserName=$userName&'
                'BusObjCode=ATTEND_BUS_New_Justification&'
                'JustificationList=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}'; //; //&FilePath=$encodedPath';

            printf('<---urlForAdd-->$urlForAdd');

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
          dropDownBannerError(AppConstants.somethingWentWrong);
        }
        hideProgress();
      } else {
        Utility.showToastMessage(AppConstants.internetConnectionError);
      }
    }
  }

}
