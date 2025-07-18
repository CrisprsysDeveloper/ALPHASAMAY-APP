import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final box = GetStorage();

  var clientId = '1';
  var userName = 'Call';

  RootModel? rootModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    printf('<----init-----MyAccount---->');
    loadSavedCredentials();
    getMyAccountDetails();
  }

  Future<void> getMyAccountDetails() async {
    await getUerAccountDetails(clientId: clientId, userName: userName);
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
        } else {
          dropDownBannerError(
            serviceStatus['MessageDescription'] ?? "Unknown error",
          );
        }

        isLoading = false;
        hideProgress();
        setState(() {});
      } catch (e, stackTrace) {
        printf("Exception: $e");
        printf("StackTrace: $stackTrace");
        dropDownBannerError("Something went wrong. Please try again.");
        isLoading = false;
        hideProgress();
        setState(() {});
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
      isLoading = false;
      hideProgress();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Account'),
          backgroundColor: Colors.white,
        ),
        body:
            !isLoading
                ? SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSectionCard(
                        title: 'General Information',
                        content: SizedBox(
                          width: Get.width,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Client ID',
                                rootModel?.userProfileList.first.clientID ?? '',
                              ),
                              _buildInfoRow(
                                'Client Name',
                                rootModel?.userProfileList.first.clientName ??
                                    '',
                              ),
                              _buildInfoRow(
                                'User Name',
                                rootModel?.userProfileList.first.userName ?? '',
                              ),
                              _buildInfoRow(
                                'Full Name',
                                rootModel?.userProfileList.first.clientName ??
                                    '',
                              ),
                              _buildInfoRow('Position', 'NA'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionCard(
                        title: 'Role Assignments',
                        content: SizedBox(
                          width: Get.width,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150.w,
                                    child: Text(
                                      'Role',
                                      style: interTextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'ValidFrom',
                                      style: interTextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'ValidTo',
                                      style: interTextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 140.w,
                                    child: Text(
                                      rootModel
                                              ?.userRoleAssignments
                                              .first
                                              .role ??
                                          '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: interTextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      rootModel
                                              ?.userRoleAssignments
                                              .first
                                              .validFrom ??
                                          '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: interTextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      rootModel
                                              ?.userRoleAssignments
                                              .first
                                              .validTo ??
                                          '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: interTextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionCard(
                        title: 'Contact Information',
                        content: SizedBox(
                          width: Get.width,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Email',
                                rootModel?.userProfileList.first.email ?? '',
                              ),
                              _buildInfoRow(
                                'Phone',
                                rootModel?.userProfileList.first.phone ?? '',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionCard(
                        title: 'Other Information',
                        content: SizedBox(
                          width: Get.width,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Time Zone',
                                rootModel
                                        ?.userProfileList
                                        .first
                                        .crisprsysTimeZone ??
                                    '',
                              ),
                              _buildInfoRow('Date Format', 'Crisprays Eportal'),
                              _buildInfoRow(
                                'Number Format',
                                'Crisprays Eportal',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(top: 16.h, right: 6.w),
                        child: GestureDetector(
                          onTap: () {
                            printf('Reset PIN tapped');
                          },
                          child: Text(
                            'RESET PIN',
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // _buildProfileCard(),
                    ],
                  ),
                )
                : SizedBox(),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: content,
          ),
        ),
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: ColorConstants.appColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: interTextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                size: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              ':  $value',
              style: interTextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                size: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RootModel {
  final ServiceStatus serviceStatus;
  final List<UserProfile> userProfileList;
  final List<UserRoleAssignment> userRoleAssignments;

  RootModel({
    required this.serviceStatus,
    required this.userProfileList,
    required this.userRoleAssignments,
  });

  factory RootModel.fromJson(Map<String, dynamic> json) {
    return RootModel(
      serviceStatus: ServiceStatus.fromJson(
        jsonDecode(json['ServiceStatus'] ?? '{}'),
      ),
      userProfileList:
          (jsonDecode(json['UserProfileList'] ?? '[]') as List)
              .map((e) => UserProfile.fromJson(e))
              .toList(),
      userRoleAssignments:
          (json['userRoleAssignements'] as List)
              .map((e) => UserRoleAssignment.fromJson(e))
              .toList(),
    );
  }
}

class ServiceStatus {
  final String messageCode;
  final String messageDescription;

  ServiceStatus({required this.messageCode, required this.messageDescription});

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      messageCode: json['MessageCode'] ?? '',
      messageDescription: json['MessageDescription'] ?? '',
    );
  }
}

class UserProfile {
  final String clientID;
  final String clientName;
  final int userID;
  final String userName;
  final String pernr;
  final String fullName;
  final String uImage;
  final String lastLogin;
  final String email;
  final String phone;
  final String pswrd;
  final bool advanceUser;
  final String mblNotificationToken;
  final String companyName;
  final String costcenterNo;
  final String deptID;
  final String position;
  final String crisprsysTimeZone;
  final String clientTimeZone;
  final String userTimeZone;

  UserProfile({
    required this.clientID,
    required this.clientName,
    required this.userID,
    required this.userName,
    required this.pernr,
    required this.fullName,
    required this.uImage,
    required this.lastLogin,
    required this.email,
    required this.phone,
    required this.pswrd,
    required this.advanceUser,
    required this.mblNotificationToken,
    required this.companyName,
    required this.costcenterNo,
    required this.deptID,
    required this.position,
    required this.crisprsysTimeZone,
    required this.clientTimeZone,
    required this.userTimeZone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      clientID: json['ClientID'] ?? '',
      clientName: json['ClientName'] ?? '',
      userID: json['UserID'] ?? 0,
      userName: json['UserName'] ?? '',
      pernr: json['PERNR'] ?? '',
      fullName: json['FullName'] ?? '',
      uImage: json['UImage'] ?? '',
      lastLogin: json['LASTLogin'] ?? '',
      email: json['Email'] ?? '',
      phone: json['Phone'] ?? '',
      pswrd: json['PSWRD'] ?? '',
      advanceUser: json['AdvanceUser'] ?? false,
      mblNotificationToken: json['MblNotificationToken'] ?? '',
      companyName: json['CompanyName'] ?? '',
      costcenterNo: json['CostcenterNo'] ?? '',
      deptID: json['DeptID'] ?? '',
      position: json['Position'] ?? '',
      crisprsysTimeZone: json['CrisprsysTimeZone'] ?? '',
      clientTimeZone: json['ClientTimeZone'] ?? '',
      userTimeZone: json['UserTimeZone'] ?? '',
    );
  }
}

class UserRoleAssignment {
  final String userName;
  final String roleID;
  final String roleCode;
  final String role;
  final String validFrom;
  final String validTo;

  UserRoleAssignment({
    required this.userName,
    required this.roleID,
    required this.roleCode,
    required this.role,
    required this.validFrom,
    required this.validTo,
  });

  factory UserRoleAssignment.fromJson(Map<String, dynamic> json) {
    return UserRoleAssignment(
      userName: json['UserName'] ?? '',
      roleID: json['RoleID'] ?? '',
      roleCode: json['RoleCode'] ?? '',
      role: json['Role'] ?? '',
      validFrom: json['ValidFrom'] ?? '',
      validTo: json['ValidTo'] ?? '',
    );
  }
}
