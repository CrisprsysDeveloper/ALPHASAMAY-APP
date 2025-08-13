import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/leave_model.dart';
import 'package:crysprsys/model/justification/justification_validation.dart';
import 'package:crysprsys/model/leave/leave_request_dropdown.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:dio/dio.dart' as dio_;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class LeaveRequestController extends GetxController {
  final TokenRepository authRepository;

  LeaveRequestController({required this.authRepository});

  TextEditingController textLeaveId = TextEditingController();
  TextEditingController textLeaveStartDate = TextEditingController();
  TextEditingController textLeaveEndDate = TextEditingController();
  TextEditingController textLeaveStatus = TextEditingController();

  TextEditingController textPendingWith = TextEditingController();
  TextEditingController textLeaveReason = TextEditingController();

  final box = GetStorage();
  var clientId = '1';
  var userName = 'Call';

  RxString defaultDate = ''.obs;
  RxString selectedInDate = ''.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final dateFormat = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('HH:mm:ss');

  var role = '';
  var roleCode = '';
  var userId = '';

  var selectedYear = '2025';

  var from = AppConstants.add;

  RxList<Employee> employeesList = <Employee>[].obs;
  RxList<LeaveType> leaveTypesList = <LeaveType>[].obs;

  Rx<Employee?> selectedEmployee = Rx<Employee?>(null);
  Rx<LeaveType?> selectedLeaveType = Rx<LeaveType?>(null);

  var selectedStartDate = '';
  var selectedEndDate = '';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--LeaveRequestController----->');
    textLeaveId.text = '0';
    loadSavedCredentials();

    try {
      from = Get.arguments['from'] ?? AppConstants.add;
      if (from == AppConstants.edit || from == AppConstants.view) {
        LeaveItem emp = Get.arguments['emp'];

        textLeaveId.text = emp.leaveID;
        textLeaveStartDate.text = convertDateFormat(emp.leaveStartDate);
        textLeaveEndDate.text = convertDateFormat(emp.leaveEndDate);
        textLeaveReason.text = emp.leaveReason;
        textLeaveStatus.text = emp.leaveStatus;

        getDropDownListApi(clientId: clientId, userName: userName).whenComplete(
          () {
            selectedEmployee.value = employeesList.firstWhere(
              (element) => element.id == emp.pernr,
            );

            selectedLeaveType.value = leaveTypesList.firstWhere(
              (element) => element.id == emp.leaveType,
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

    //getDropDownListApi(clientId: clientId, userName: userName);
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

  String convertDateFormat(String inputDate) {
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(inputDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return ''; // or handle the error appropriately
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: today, //DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedInDate.value =
          picked.toUtc().toIso8601String(); // "2025-02-06T05:00:00.000Z"
      printf('Selected UTC Date: $selectedInDate');

      textLeaveStartDate.text = dateFormat.format(picked);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: today, //DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedInDate.value = picked.toUtc().toIso8601String();
      printf('Selected UTC Date: $selectedInDate');
      textLeaveEndDate.text = dateFormat.format(picked);

      selectedYear = picked.year.toString();
      printf('Selected Year: $selectedYear');
    }
  }

  Future<void> getDropDownListApi({
    required String clientId,
    required String userName,
  }) async {
    printf('<--getDropDownListApi--clientId-$clientId--userName-->$userName');

    const String baseUrl = AppConstants.baseUrl;
    const String endpoint = AppConstants.getLeaveRequestDropDownListApi;

    final dio = Dio();

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();

        final uri = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'BusObjCode': 'LM_LR_BUS_NT',
            'ScreenMode': '',
          },
        );

        printf('Full URL: $uri');

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'BusObjCode': 'LM_LR_BUS_NT',
            'ScreenMode': '',
          },
        );

        hideProgress();
        printf('<----response---->${response.data}');

        if (response.data != null && response.data is Map<String, dynamic>) {
          final data = LeaveScreenData.fromJson(response.data);

          employeesList.value = data.employeesList;
          leaveTypesList.value = data.leaveTypesList;

          printf('---emp-list-->${employeesList.length}');
          printf('---leave-type-list-->${leaveTypesList.length}');

          if (employeesList.isNotEmpty) {
            selectedEmployee.value = employeesList.first;
          }

          if (leaveTypesList.isNotEmpty) {
            selectedLeaveType.value = leaveTypesList.first;
          }
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

  Future<void> buttonCreateLeaveRequest(from) async {
    if (textLeaveId.text.isEmpty) {
      dropDownBannerError('Please enter leave id');
    } else if (textLeaveStartDate.text.isEmpty) {
      dropDownBannerError('Please enter start date');
    } else if (textLeaveEndDate.text.isEmpty) {
      dropDownBannerError('Please enter end date');
    } else if (textLeaveReason.text.isEmpty) {
      dropDownBannerError('Please add leave reason ');
    } else {
      printf('<----create-leave-request--->');

      var validationVariables = {
        "BusObjCode": "LM_LR_BUS_NT",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": textLeaveId.text,
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? 'SAVE' : 'SUBMIT',
        "ScreenMode": 'Create',
        "UserID": userId,
        "RoleID": clientId,
        "Notification_ID": "",
        "Year": selectedYear,
      };

      printf(
        'Validation Variable payload :\n${jsonEncode(validationVariables)}',
      );

      var justifyList = {
        "LeaveID": textLeaveId.text,
        "PERNR": selectedEmployee.value?.id,
        "UserName": selectedEmployee.value?.id,
        "LeaveStartDate": textLeaveStartDate.text, //"2025-08-07T18:30:00.000Z",
        "LeaveEndDate": textLeaveEndDate.text, //"2025-08-07T18:30:00.000Z",
        "LeaveType": selectedLeaveType.value?.id,
        "LeaveStatus": "Saved",
        "LeaveReason": textLeaveReason.text,
        "IsAdvanceLeave": true,
      };

      printf('Justification List payload:\n${jsonEncode(justifyList)}');

      var approvalData = {
        "Status": "Saved",
        "AppCode": "LM",
        "BusObjectDesc": "Leave Request Overview",
        "MemberStatus": "",
        "SaveOrSubmit": "SAVE",
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": userId,
        "baseUrl": "https://eportal.crisprsys.net",
        "UserAction": "SAVE",
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf(
        '<--create-leave-request-clientId-$clientId--userName-->$userName',
      );

      const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
      const String endpoint = AppConstants.validationForCreateLeaveRequestApi;

      final url =
          '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
          'ValidationVariables=${jsonEncode(validationVariables)}&'
          'LeaveRequestJsonData=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      if (await InternetConnection().hasInternetAccess) {
        showProgress();
        final url =
            '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
            'ValidationVariables=${jsonEncode(validationVariables)}&'
            'LeaveRequestJsonData=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

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
            printf('<--call-create-leave-request---->');

            const String baseUrl = AppConstants.baseUrl;
            const String endpoint = AppConstants.createLeaveRequestApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            final urlForAdd =
                '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
                'BusObjCode=LM_LR_BUS_NT&'
                'LeaveRquestObject=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}&'
                'DocumentsList=null&'
                'StorageLocation=AWS';

            printf('<---urlForAdd-->$urlForAdd');

            final dio = dio_.Dio();
            final res = await dio.get(urlForAdd);

            printf('Response runtimeType: ${res.data.runtimeType}');
            printf('Raw response: ${res.data}');

            final message =
                res.data['MessageText']?.toString() ?? 'No message provided';

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

  Future<void> buttonEditLeaveRequest(from) async {
    if (textLeaveId.text.isEmpty) {
      dropDownBannerError('Please enter leave id');
    } else if (textLeaveStartDate.text.isEmpty) {
      dropDownBannerError('Please enter start date');
    } else if (textLeaveEndDate.text.isEmpty) {
      dropDownBannerError('Please enter end date');
    } else if (textLeaveReason.text.isEmpty) {
      dropDownBannerError('Please add leave reason ');
    } else {
      printf('<----edit-leave-request--->');

      var validationVariables = {
        "BusObjCode": "LM_LR_BUS_NT",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": textLeaveId.text,
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? 'SAVE' : 'SUBMIT',
        "ScreenMode": 'Create',
        "UserID": userId,
        "RoleID": clientId,
        "Notification_ID": "",
        "Year": selectedYear,
      };

      printf(
        'Validation Variable payload :\n${jsonEncode(validationVariables)}',
      );

      var justifyList = {
        "LeaveID": textLeaveId.text,
        "PERNR": selectedEmployee.value?.id,
        "UserName": selectedEmployee.value?.id,
        "LeaveStartDate": textLeaveStartDate.text, //"2025-08-07T18:30:00.000Z",
        "LeaveEndDate": textLeaveEndDate.text, //"2025-08-07T18:30:00.000Z",
        "LeaveType": selectedLeaveType.value?.id,
        "LeaveStatus": "Saved",
        "LeaveReason": textLeaveReason.text,
        "IsAdvanceLeave": true,
      };

      printf('Justification List payload:\n${jsonEncode(justifyList)}');

      var approvalData = {
        "Status": "Saved",
        "AppCode": "LM",
        "BusObjectDesc": "Leave Request Overview",
        "MemberStatus": "",
        "SaveOrSubmit": "SAVE",
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": userId,
        "baseUrl": "https://eportal.crisprsys.net",
        "UserAction": "SAVE",
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf('<--edit-leave-request-clientId-$clientId--userName-->$userName');

      const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
      const String endpoint = AppConstants.validationForCreateLeaveRequestApi;

      final url =
          '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
          'ValidationVariables=${jsonEncode(validationVariables)}&'
          'LeaveRequestJsonData=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      if (await InternetConnection().hasInternetAccess) {
        showProgress();
        final url =
            '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
            'ValidationVariables=${jsonEncode(validationVariables)}&'
            'LeaveRequestJsonData=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

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
            printf('<--call-create-leave-request---->');

            const String baseUrl = AppConstants.baseUrl;
            const String endpoint = AppConstants.updateLeaveRequestApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            final urlForAdd =
                '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
                'LeaveID=${textLeaveId.text}&'
                'BusObjCode=LM_LR_BUS_NT&'
                'LeaveRquestObject=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}';

            printf('<---urlForAdd-->$urlForAdd');

            final dio = dio_.Dio();
            final res = await dio.get(urlForAdd);

            printf('Response runtimeType: ${res.data.runtimeType}');
            printf('Raw response: ${res.data}');

            final message =
                res.data['MessageText']?.toString() ?? 'No message provided';

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

  Future<void> buttonUpdateLeaveRequest(from) async {
    printf('<---button-update-leave-request--->');
    if (textLeaveId.text.isEmpty) {
      dropDownBannerError('Please enter leave id');
    } else if (textLeaveStartDate.text.isEmpty) {
      dropDownBannerError('Please enter start date');
    } else if (textLeaveEndDate.text.isEmpty) {
      dropDownBannerError('Please enter end date');
    } else if (textLeaveReason.text.isEmpty) {
      dropDownBannerError('Please add leave reason ');
    } else {
      printf('<----update-leave-request--->');

      var validationVariables = {
        "BusObjCode": "LM_LR_BUS_NT",
        "ControlID": from == 'save' ? '5' : '6',
        "ObjectNo": textLeaveId.text,
        "IsApprovalPreCondition": 'ActionBased',
        "MemberID": userId,
        "ActionText": from == 'save' ? 'SAVE' : 'SUBMIT',
        "ScreenMode": 'Create',
        "UserID": userId,
        "RoleID": clientId,
        "Notification_ID": "",
        "Year": selectedYear,
      };

      printf(
        'Validation Variable payload :\n${jsonEncode(validationVariables)}',
      );

      var justifyList = {
        "LeaveID": textLeaveId.text,
        "PERNR": selectedEmployee.value?.id,
        "UserName": selectedEmployee.value?.id,
        "LeaveStartDate": textLeaveStartDate.text, //"2025-08-07T18:30:00.000Z",
        "LeaveEndDate": textLeaveEndDate.text, //"2025-08-07T18:30:00.000Z",
        "LeaveType": selectedLeaveType.value?.id,
        "LeaveStatus": "Saved",
        "LeaveReason": textLeaveReason.text,
        "IsAdvanceLeave": true,
      };

      printf('Justification List payload:\n${jsonEncode(justifyList)}');

      var approvalData = {
        "Status": "Saved",
        "AppCode": "LM",
        "BusObjectDesc": "Leave Request Overview",
        "MemberStatus": "",
        "SaveOrSubmit": from == 'save' ? 'SAVE' : 'SUBMIT',
        "apiUrl": "https://apis.crisprsys.net/api/",
        "EmployeeID": userId,
        "baseUrl": "https://eportal.crisprsys.net",
        "UserAction": from == 'save' ? 'SAVE' : 'SUBMIT',
      };

      printf('approvalData  payload:\n${jsonEncode(approvalData)}');

      printf(
        '<--create-leave-request-clientId-$clientId--userName-->$userName',
      );

      const String baseUrl = AppConstants.baseUrl;
      const String endpoint = AppConstants.validationForCreateLeaveRequestApi;

      final url =
          '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
          'ValidationVariables=${jsonEncode(validationVariables)}&'
          'LeaveRequestJsonData=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

      printf('<---url-->$url');

      if (await InternetConnection().hasInternetAccess) {
        showProgress();
        final url =
            '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
            'ValidationVariables=${jsonEncode(validationVariables)}&'
            'LeaveRequestJsonData=${jsonEncode(justifyList)}'; //; //&FilePath=$encodedPath';

        printf('<---url-->$url');

        final dio = dio_.Dio();
        final response = await dio.get(url);
        printf('<---response-for-validation-->$response');

        // printf('Response runtimeType: ${response.data.runtimeType}');
        //printf('Raw response: ${response.data}');

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
            printf('<--call-edit-leave-request---->');

            const String baseUrl = AppConstants.baseUrl;
            const String endpoint = AppConstants.updateLeaveRequestApi;

            final teamMembersEncoded = Uri.encodeComponent(
              jsonEncode(teamMembersList.map((e) => e.toJson()).toList()),
            );

            final urlForAdd =
                '$baseUrl$endpoint?ClientID=$clientId&UserName=$userName&'
                'LeaveID=${textLeaveId.text}&'
                'BusObjCode=LM_LR_BUS_NT&'
                'LeaveRquestObject=${jsonEncode(justifyList)}&'
                'TeamMembersJsonData=$teamMembersEncoded&'
                'ApprovalData=${jsonEncode(approvalData)}';
            //'StorageLocation=';

            printf('<---urlForUpdate-->$urlForAdd');

            final dio = dio_.Dio();
            final res = await dio.get(urlForAdd);

            printf('Response runtimeType: ${res.data.runtimeType}');
            printf('Raw response: ${res.data}');

            final message =
                res.data['MessageText']?.toString() ?? 'No message provided';

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
