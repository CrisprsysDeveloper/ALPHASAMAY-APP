import 'dart:convert';

class TimeEventModel {
  final ServiceStatus serviceStatus;
  final List<dynamic> attendanceList;
  final List<Employee> employeeList;
  final List<ScreenControl> screenCntrlsList;
  final List<YearMonth> objYearsList;
  final List<YearMonth> objMonthsList;
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
      attendanceList: json['AttendanceList'],
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
      objMonthsList: List<YearMonth>.from(
        json['ObjMonthsList'].map((e) => YearMonth.fromJson(e)),
      ),
      employeeNumber: json['EmployeeNumber'],
      authEventType: json['AuthEventType'],
    );
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
