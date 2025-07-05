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

class AttendanceModel {
  final String partnerType;
  final String employeeID;
  final String employeeName;
  final String checkInDate;
  final String? inDate;
  final String? checktime;
  final String? checkType;
  final int? checkInId;
  final String? latitude;
  final String? longitude;
  final String? changedBy;
  final bool? isManuallyDone;
  final String? createdDate;
  final String? createdTime;
  final String? pernr;
  final String? deptID;
  final String? ccntr;
  final String? ccode;
  final bool? faceScanRequired;
  final bool? isOTHoursApplicable;

  AttendanceModel({
    required this.partnerType,
    required this.employeeID,
    required this.employeeName,
    required this.checkInDate,
    this.inDate,
    this.checktime,
    this.checkType,
    this.checkInId,
    this.latitude,
    this.longitude,
    this.changedBy,
    this.isManuallyDone,
    this.createdDate,
    this.createdTime,
    this.pernr,
    this.deptID,
    this.ccntr,
    this.ccode,
    this.faceScanRequired,
    this.isOTHoursApplicable,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      partnerType: json['PartnerType'] ?? '',
      employeeID: json['EmployeeID'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
      checkInDate: json['CheckInDate'] ?? '',
      inDate: json['InDate'],
      checktime: json['Checktime'],
      checkType: json['CheckType'],
      checkInId: json['CheckInId'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      changedBy: json['ChangedBy'],
      isManuallyDone: json['IsmanuallyDone'],
      createdDate: json['CreatedDate'],
      createdTime: json['CreatedTime'],
      pernr: json['PERNR'],
      deptID: json['DeptID'],
      ccntr: json['CCNTR'],
      ccode: json['CCODE'],
      faceScanRequired: json['FaceScanRequired'],
      isOTHoursApplicable: json['IsOTHoursApplicable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PartnerType': partnerType,
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'CheckInDate': checkInDate,
      'InDate': inDate,
      'Checktime': checktime,
      'CheckType': checkType,
      'CheckInId': checkInId,
      'Latitude': latitude,
      'Longitude': longitude,
      'ChangedBy': changedBy,
      'IsmanuallyDone': isManuallyDone,
      'CreatedDate': createdDate,
      'CreatedTime': createdTime,
      'PERNR': pernr,
      'DeptID': deptID,
      'CCNTR': ccntr,
      'CCODE': ccode,
      'FaceScanRequired': faceScanRequired,
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
