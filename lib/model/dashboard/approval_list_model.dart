import 'dart:convert';

class AttendanceResponse {
  final ServiceStatus serviceStatus;
  final List<Attendance> attendanceList;

  AttendanceResponse({
    required this.serviceStatus,
    required this.attendanceList,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      serviceStatus: ServiceStatus.fromJson(jsonDecode(json['ServiceStatus'])),
      attendanceList:
          (json['AttendanceList'] as List)
              .map((e) => Attendance.fromJson(e))
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
      messageCode: json['MessageCode'],
      messageDescription: json['MessageDescription'],
    );
  }
}

class Attendance {
  final String employeeID;
  final String employeeName;
  final String checkInDate;
  final String checktime;
  final String checkType;
  final String checkinapprovalstatus;
  final String? regUserProfilePath;
  final String? checkinUserProfilePath;
  final double? profileMatchingPercentage;
  int? checkInId;

  Attendance({
    required this.employeeID,
    required this.employeeName,
    required this.checkInDate,
    required this.checktime,
    required this.checkType,
    required this.checkinapprovalstatus,
    this.regUserProfilePath,
    this.checkinUserProfilePath,
    this.profileMatchingPercentage,
    this.checkInId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      employeeID: json['EmployeeID'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
      checkInDate: json['CheckInDate'] ?? '',
      checktime: json['Checktime'] ?? '',
      checkType: json['CheckType'] ?? '',
      checkinapprovalstatus: json['checkinapprovalstatus'] ?? '',
      regUserProfilePath: json['RegUserProfilePath'],
      checkinUserProfilePath: json['CheckinUserProfilePath'],
      checkInId: json['CheckInId'] ?? 0,
      profileMatchingPercentage:
          (json['ProfileMatchingPercentage'] ?? 0.0).toDouble(),
    );
  }
}
