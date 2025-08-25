import 'dart:convert';

class RootResponse {
  final ServiceStatus serviceStatus;
  final DBReportFieldsResult dBReportFieldsResult;

  RootResponse({
    required this.serviceStatus,
    required this.dBReportFieldsResult,
  });

  factory RootResponse.fromJson(Map<String, dynamic> json) {
    return RootResponse(
      serviceStatus: ServiceStatus.fromJson(
        json['ServiceStatus'] != null
            ? _decodeNestedJson(json['ServiceStatus'])
            : {},
      ),
      dBReportFieldsResult: DBReportFieldsResult.fromJson(
        json['dBReportFieldsResult'] ?? {},
      ),
    );
  }

  static Map<String, dynamic> _decodeNestedJson(dynamic value) {
    try {
      if (value is String) {
        return value.isNotEmpty ? Map<String, dynamic>.from(jsonDecode(value)) : {};
      }
      return {};
    } catch (_) {
      return {};
    }
  }
}

class ServiceStatus {
  final String messageCode;
  final String messageDescription;

  ServiceStatus({
    this.messageCode = '',
    this.messageDescription = '',
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      messageCode: json['MessageCode'] ?? '',
      messageDescription: json['MessageDescription'] ?? '',
    );
  }
}

class DBReportFieldsResult {
  final String reportFields;
  final List<Employee> employees;
  final bool skftype;
  final String tileCode;
  final String typeOfReport;
  final String graphType;
  final String skfCode;
  final String countBy;

  DBReportFieldsResult({
    this.reportFields = '',
    this.employees = const [],
    this.skftype = false,
    this.tileCode = '',
    this.typeOfReport = '',
    this.graphType = '',
    this.skfCode = '',
    this.countBy = '',
  });

  factory DBReportFieldsResult.fromJson(Map<String, dynamic> json) {
    List<Employee> employeesList = [];
    try {
      if (json['resultJson'] != null && json['resultJson'].toString().isNotEmpty) {
        final decodedList = jsonDecode(json['resultJson']);
        if (decodedList is List) {
          employeesList = decodedList.map((e) => Employee.fromJson(e)).toList();
        }
      }
    } catch (_) {}

    return DBReportFieldsResult(
      reportFields: json['ReportFields'] ?? '',
      employees: employeesList,
      skftype: json['skftype'] ?? false,
      tileCode: json['TileCode'] ?? '',
      typeOfReport: json['TypeOfReport'] ?? '',
      graphType: json['GraphType'] ?? '',
      skfCode: json['SkfCode'] ?? '',
      countBy: json['CountBy'] ?? '',
    );
  }
}

class Employee {
  final String employeeNo;
  final String name;
  final String position;
  final String department;
  final String dateOfJoining;

  Employee({
    this.employeeNo = '',
    this.name = '',
    this.position = '',
    this.department = '',
    this.dateOfJoining = '',
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeNo: json['EmployeeNo'] ?? '',
      name: json['Name'] ?? '',
      position: json['Position'] ?? '',
      department: json['Department'] ?? '',
      dateOfJoining: json['DateOfJoining'] ?? '',
    );
  }
}
