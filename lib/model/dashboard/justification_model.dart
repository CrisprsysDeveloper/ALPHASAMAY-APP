import 'dart:convert';

class JustificationModel {
  final ServiceStatus serviceStatus;
  final JustifyResults justifyResults;
  final List<Employee> employeeList;
  final List<YearMonth> objYearsList;
  final List<Month> objMonthsList;
  final String employeeNumber;
  final String authEventType;

  JustificationModel({
    required this.serviceStatus,
    required this.justifyResults,
    required this.employeeList,
    required this.objYearsList,
    required this.objMonthsList,
    required this.employeeNumber,
    required this.authEventType,
  });

  factory JustificationModel.fromJson(Map<String, dynamic> json) {
    return JustificationModel(
      serviceStatus: ServiceStatus.fromJson(jsonDecode(json['ServiceStatus'])),
      justifyResults: JustifyResults.fromJson(json['justifyResults']),
      employeeList: List<Employee>.from(
        jsonDecode(json['EmployeeList']).map((e) => Employee.fromJson(e)),
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

class JustifyResults {
  final List<JustificationItem> justificationList;

  JustifyResults({required this.justificationList});

  factory JustifyResults.fromJson(Map<String, dynamic> json) {
    return JustifyResults(
      justificationList: List<JustificationItem>.from(
        json['JustificationList'].map((e) => JustificationItem.fromJson(e)),
      ),
    );
  }
}

class JustificationItem {
  final int jid;
  final String justid;
  final String partnerType;
  final String employeeID;
  final String employeeName;
  final String date;
  final String justifyComments;
  final String status;
  final String timeIn;
  final String timeOut;

  JustificationItem({
    required this.jid,
    required this.justid,
    required this.partnerType,
    required this.employeeID,
    required this.employeeName,
    required this.date,
    required this.justifyComments,
    required this.status,
    required this.timeIn,
    required this.timeOut,
  });

  factory JustificationItem.fromJson(Map<String, dynamic> json) {
    return JustificationItem(
      jid: json['JID'],
      justid: json['JUSTID'],
      partnerType: json['PartnerType'],
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      date: json['Date'],
      justifyComments: json['JustifyComments'] ?? '',
      status: json['Status'] ?? '',
      timeIn: json['InTime'] ?? '',
      timeOut: json['OutTime'] ?? '',
    );
  }
}

class Employee {
  final String id;
  final String value;

  Employee({required this.id, required this.value});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(id: json['Id'], value: json['Value']);
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
      defaultValue: json['DefaultValue'],
    );
  }
}
