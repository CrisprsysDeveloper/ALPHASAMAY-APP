import 'dart:convert';

class TimeEventModel {
  final ServiceStatus serviceStatus;
  final List<AttendanceModel> attendanceList;
  final List<Employee> employeeList;
  final List<ScreenControl> screenCntrlsList;
  final List<YearMonth> objYearsList;
  final List<Month> objMonthsList;
  final String employeeNumber;
  final String authEventType;

  TimeEventModel({
    required this.serviceStatus,
    required this.attendanceList,
    required this.employeeList,
    required this.screenCntrlsList,
    required this.objYearsList,
    required this.objMonthsList,
    required this.employeeNumber,
    required this.authEventType,
  });

  factory TimeEventModel.fromJson(Map<String, dynamic> json) {
    return TimeEventModel(
      serviceStatus: ServiceStatus.fromJson(jsonDecode(json['ServiceStatus'])),
      attendanceList: List<AttendanceModel>.from(
        json['AttendanceList'].map((e) => AttendanceModel.fromJson(e)),
      ),
      employeeList: List<Employee>.from(
        json['EmployeeList'].map((e) => Employee.fromJson(e)),
      ),
      screenCntrlsList: List<ScreenControl>.from(
        jsonDecode(
          json['ScreenCntrlsList'],
        ).map((e) => ScreenControl.fromJson(e)),
      ),
      objYearsList: List<YearMonth>.from(
        json['ObjYearsList'].map((e) => YearMonth.fromJson(e)),
      ),
      objMonthsList: List<Month>.from(
        json['ObjMonthsList'].map((e) => Month.fromJson(e)),
      ),
      employeeNumber: json['EmployeeNumber'],
      authEventType: json['AuthEventType'],
    );
  }
}

// class AttendanceModel {
//   final String partnerType;
//   final String employeeID;
//   final String employeeName;
//   final String checkInDate;
//   final String? inDate;
//   final String? checktime;
//   final String? checkType;
//   final int? checkInId;
//   final String? latitude;
//   final String? longitude;
//   final String? changedBy;
//   final bool? isManuallyDone;
//   final String? createdDate;
//   final String? createdTime;
//   final String? pernr;
//   final String? deptID;
//   final String? ccntr;
//   final String? ccode;
//   final bool? faceScanRequired;
//   final bool? isOTHoursApplicable;
//
//   AttendanceModel({
//     required this.partnerType,
//     required this.employeeID,
//     required this.employeeName,
//     required this.checkInDate,
//     this.inDate,
//     this.checktime,
//     this.checkType,
//     this.checkInId,
//     this.latitude,
//     this.longitude,
//     this.changedBy,
//     this.isManuallyDone,
//     this.createdDate,
//     this.createdTime,
//     this.pernr,
//     this.deptID,
//     this.ccntr,
//     this.ccode,
//     this.faceScanRequired,
//     this.isOTHoursApplicable,
//   });
//
//   factory AttendanceModel.fromJson(Map<String, dynamic> json) {
//     return AttendanceModel(
//       partnerType: json['PartnerType'] ?? '',
//       employeeID: json['EmployeeID'] ?? '',
//       employeeName: json['EmployeeName'] ?? '',
//       checkInDate: json['CheckInDate'] ?? '',
//       inDate: json['InDate'],
//       checktime: json['Checktime'],
//       checkType: json['CheckType'],
//       checkInId: json['CheckInId'],
//       latitude: json['Latitude'],
//       longitude: json['Longitude'],
//       changedBy: json['ChangedBy'],
//       isManuallyDone: json['IsmanuallyDone'],
//       createdDate: json['CreatedDate'],
//       createdTime: json['CreatedTime'],
//       pernr: json['PERNR'],
//       deptID: json['DeptID'],
//       ccntr: json['CCNTR'],
//       ccode: json['CCODE'],
//       faceScanRequired: json['FaceScanRequired'],
//       isOTHoursApplicable: json['IsOTHoursApplicable'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'PartnerType': partnerType,
//       'EmployeeID': employeeID,
//       'EmployeeName': employeeName,
//       'CheckInDate': checkInDate,
//       'InDate': inDate,
//       'Checktime': checktime,
//       'CheckType': checkType,
//       'CheckInId': checkInId,
//       'Latitude': latitude,
//       'Longitude': longitude,
//       'ChangedBy': changedBy,
//       'IsmanuallyDone': isManuallyDone,
//       'CreatedDate': createdDate,
//       'CreatedTime': createdTime,
//       'PERNR': pernr,
//       'DeptID': deptID,
//       'CCNTR': ccntr,
//       'CCODE': ccode,
//       'FaceScanRequired': faceScanRequired,
//       'IsOTHoursApplicable': isOTHoursApplicable,
//     };
//   }
// }

class AttendanceModel {
  final String partnerType;
  final String employeeID;
  final String employeeName;
  final String checkInDate;
  final String? userType;
  final String? inDate;
  final bool manuallyDone;
  final String duplicateDate;
  final String? checktime;
  final String? checkType;
  final String? verifycode;
  final String? timezones;
  final String? status;
  final String? remarks;
  final int? checkInId;
  final String? mainCheckStatus;
  final String? deviceSno;
  final String? latitude;
  final String? parameterLatitude;
  final String? longitude;
  final String? parameterLongitude;
  final String? changedBy;
  final bool? isManuallyDone;
  final String? createdBy;
  final String? createdDate;
  final String? createdTime;
  final String? filePath;
  final String? busObjCode;
  final String? regUserProfile;
  final String? checkinUserProfile;
  final String? regUserPhotoKey;
  final String? checkinPhotoKey;
  final String? checkinApprovalStatus;
  final String? regUserProfilePath;
  final String? checkinUserProfilePath;
  final String? convertedCheckinDate;
  final double? profileMatchingPercentage;
  final String? pernr;
  final String? deptID;
  final String? ccntr;
  final String? prjnr;
  final String? ccode;
  final bool? faceScanRequired;
  final String? requestFrom;
  final String? projFeedbackType;
  final String? proactive;
  final String? reactive;
  final String? actionType;
  final bool? isOTHoursApplicable;

  AttendanceModel({
    required this.partnerType,
    required this.employeeID,
    required this.employeeName,
    required this.checkInDate,
    this.userType,
    this.inDate,
    this.manuallyDone = false,
    this.duplicateDate = '',
    this.checktime,
    this.checkType,
    this.verifycode,
    this.timezones,
    this.status,
    this.remarks,
    this.checkInId,
    this.mainCheckStatus,
    this.deviceSno,
    this.latitude,
    this.parameterLatitude,
    this.longitude,
    this.parameterLongitude,
    this.changedBy,
    this.isManuallyDone,
    this.createdBy,
    this.createdDate,
    this.createdTime,
    this.filePath,
    this.busObjCode,
    this.regUserProfile,
    this.checkinUserProfile,
    this.regUserPhotoKey,
    this.checkinPhotoKey,
    this.checkinApprovalStatus,
    this.regUserProfilePath,
    this.checkinUserProfilePath,
    this.convertedCheckinDate,
    this.profileMatchingPercentage,
    this.pernr,
    this.deptID,
    this.ccntr,
    this.prjnr,
    this.ccode,
    this.faceScanRequired,
    this.requestFrom,
    this.projFeedbackType,
    this.proactive,
    this.reactive,
    this.actionType,
    this.isOTHoursApplicable,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      partnerType: json['PartnerType'] ?? '',
      employeeID: json['EmployeeID'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
      checkInDate: json['CheckInDate'] ?? '',
      userType: json['UserType'],
      inDate: json['InDate'],
      manuallyDone: json['ManuallyDone'] ?? false,
      duplicateDate: json['DuplicateDate'] ?? '',
      checktime: json['Checktime'],
      checkType: json['CheckType'],
      verifycode: json['verifycode'],
      timezones: json['timezones'],
      status: json['Status'],
      remarks: json['Remarks'],
      checkInId: json['CheckInId'],
      mainCheckStatus: json['MainCheckStatus'],
      deviceSno: json['DeviceSno'],
      latitude: json['Latitude'],
      parameterLatitude: json['ParameterLatitude'],
      longitude: json['Longitude'],
      parameterLongitude: json['ParameterLongitude'],
      changedBy: json['ChangedBy'],
      isManuallyDone: json['IsmanuallyDone'],
      createdBy: json['CreatedBy'],
      createdDate: json['CreatedDate'],
      createdTime: json['CreatedTime'],
      filePath: json['filePath'],
      busObjCode: json['BusObjCode'],
      regUserProfile: json['RegUserProfile'],
      checkinUserProfile: json['CheckinUserProfile'],
      regUserPhotoKey: json['RegUserPhotoKey'],
      checkinPhotoKey: json['CheckinPhotoKey'],
      checkinApprovalStatus: json['checkinapprovalstatus'],
      regUserProfilePath: json['RegUserProfilePath'],
      checkinUserProfilePath: json['CheckinUserProfilePath'],
      convertedCheckinDate: json['ConvertedCheckinDate'],
      profileMatchingPercentage:
      (json['ProfileMatchingPercentage'] ?? 0).toDouble(),
      pernr: json['PERNR'],
      deptID: json['DeptID'],
      ccntr: json['CCNTR'],
      prjnr: json['PRJNR'],
      ccode: json['CCODE'],
      faceScanRequired: json['FaceScanRequired'],
      requestFrom: json['RequestFrom'],
      projFeedbackType: json['PROJFeedbackType'],
      proactive: json['Proactive'],
      reactive: json['Reactive'],
      actionType: json['ActionType'],
      isOTHoursApplicable: json['IsOTHoursApplicable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PartnerType': partnerType,
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'CheckInDate': checkInDate,
      'UserType': userType,
      'InDate': inDate,
      'ManuallyDone': manuallyDone,
      'DuplicateDate': duplicateDate,
      'Checktime': checktime,
      'CheckType': checkType,
      'verifycode': verifycode,
      'timezones': timezones,
      'Status': status,
      'Remarks': remarks,
      'CheckInId': checkInId,
      'MainCheckStatus': mainCheckStatus,
      'DeviceSno': deviceSno,
      'Latitude': latitude,
      'ParameterLatitude': parameterLatitude,
      'Longitude': longitude,
      'ParameterLongitude': parameterLongitude,
      'ChangedBy': changedBy,
      'IsmanuallyDone': isManuallyDone,
      'CreatedBy': createdBy,
      'CreatedDate': createdDate,
      'CreatedTime': createdTime,
      'filePath': filePath,
      'BusObjCode': busObjCode,
      'RegUserProfile': regUserProfile,
      'CheckinUserProfile': checkinUserProfile,
      'RegUserPhotoKey': regUserPhotoKey,
      'CheckinPhotoKey': checkinPhotoKey,
      'checkinapprovalstatus': checkinApprovalStatus,
      'RegUserProfilePath': regUserProfilePath,
      'CheckinUserProfilePath': checkinUserProfilePath,
      'ConvertedCheckinDate': convertedCheckinDate,
      'ProfileMatchingPercentage': profileMatchingPercentage,
      'PERNR': pernr,
      'DeptID': deptID,
      'CCNTR': ccntr,
      'PRJNR': prjnr,
      'CCODE': ccode,
      'FaceScanRequired': faceScanRequired,
      'RequestFrom': requestFrom,
      'PROJFeedbackType': projFeedbackType,
      'Proactive': proactive,
      'Reactive': reactive,
      'ActionType': actionType,
      'IsOTHoursApplicable': isOTHoursApplicable,
    };
  }
}


class Employee {
  final String id;
  final String value;
  final bool defaultValue;

  Employee({required this.id, required this.value, required this.defaultValue});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['ID'],
      value: json['Value'],
      defaultValue: json['DefaultValue'],
    );
  }
}

class ScreenControl {
  final String control;
  final String icon;
  final String modeName;
  final String controlCode;
  final int controlID;

  ScreenControl({
    required this.control,
    required this.icon,
    required this.modeName,
    required this.controlCode,
    required this.controlID,
  });

  factory ScreenControl.fromJson(Map<String, dynamic> json) {
    return ScreenControl(
      control: json['Control'],
      icon: json['Icon'],
      modeName: json['ModeName'],
      controlCode: json['ControlCode'],
      controlID: json['ControlID'],
    );
  }
}

class YearMonth {
  final String id;
  final String value;
  final bool defaultValue;

  YearMonth({
    required this.id,
    required this.value,
    required this.defaultValue,
  });

  factory YearMonth.fromJson(Map<String, dynamic> json) {
    return YearMonth(
      id: json['ID'],
      value: json['Value'],
      defaultValue: json['DefaultValue'],
    );
  }
}

class Month {
  final String id;
  final String value;
  final bool defaultValue;

  Month({required this.id, required this.value, required this.defaultValue});

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      id: json['ID'],
      value: json['Value'],
      defaultValue: json['DefaultValue'] ?? false,
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
