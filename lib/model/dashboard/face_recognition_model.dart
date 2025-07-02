import 'dart:convert';

class FaceRecognitionResponse {
  final ServiceStatus serviceStatus;
  final List<AttendanceUser> attendanceUserList;
  final List<ScreenControl> screenControlsList;

  FaceRecognitionResponse({
    required this.serviceStatus,
    required this.attendanceUserList,
    required this.screenControlsList,
  });

  factory FaceRecognitionResponse.fromJson(Map<String, dynamic> json) {
    return FaceRecognitionResponse(
      serviceStatus:
      ServiceStatus.fromJson(jsonDecode(json['ServiceStatus'])),
      attendanceUserList: (json['AttendanceUserList'] as List<dynamic>?)
          ?.map((e) => AttendanceUser.fromJson(e))
          .toList() ??
          [],
      screenControlsList: (json['ScreenCntrlsList'] as List<dynamic>?)
          ?.map((e) => ScreenControl.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class ServiceStatus {
  final String messageCode;
  final String messageDescription;

  ServiceStatus({
    required this.messageCode,
    required this.messageDescription,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      messageCode: json['MessageCode'],
      messageDescription: json['MessageDescription'],
    );
  }
}

class AttendanceUser {
  final String faceRegID;
  final String busObjCode;
  final String objectNo;
  final String awsPhotoKey;
  final String attendanceUserUImage;
  final String pernr;
  final String deptID;
  final String ccntr;
  final String prjnr;
  final String ccode;
  final String faceId;

  AttendanceUser({
    required this.faceRegID,
    required this.busObjCode,
    required this.objectNo,
    required this.awsPhotoKey,
    required this.attendanceUserUImage,
    required this.pernr,
    required this.deptID,
    required this.ccntr,
    required this.prjnr,
    required this.ccode,
    required this.faceId,
  });

  factory AttendanceUser.fromJson(Map<String, dynamic> json) {
    return AttendanceUser(
      faceRegID: json['FaceRegID'] ?? '',
      busObjCode: json['BusObjCode'] ?? '',
      objectNo: json['ObjectNo'] ?? '',
      awsPhotoKey: json['AwsPhotoKey'] ?? '',
      attendanceUserUImage: json['AttendanceUserUImage'] ?? '',
      pernr: json['PERNR'] ?? '',
      deptID: json['DeptID'] ?? '',
      ccntr: json['CCNTR'] ?? '',
      prjnr: json['PRJNR'] ?? '',
      ccode: json['CCODE'] ?? '',
      faceId: json['FaceId'] ?? '',
    );
  }
}

class ScreenControl {
  final String control;
  final String icon;
  final String? roleId;
  final String modeName;
  final String controlCode;
  final int controlId;
  final String? statusDesc;
  final String? taskStatus;

  ScreenControl({
    required this.control,
    required this.icon,
    required this.roleId,
    required this.modeName,
    required this.controlCode,
    required this.controlId,
    required this.statusDesc,
    required this.taskStatus,
  });

  factory ScreenControl.fromJson(Map<String, dynamic> json) {
    return ScreenControl(
      control: json['Control'] ?? '',
      icon: json['Icon'] ?? '',
      roleId: json['RoleID'],
      modeName: json['ModeName'] ?? '',
      controlCode: json['ControlCode'] ?? '',
      controlId: json['ControlID'] ?? 0,
      statusDesc: json['StatusDesc'],
      taskStatus: json['TaskStatus'],
    );
  }
}
