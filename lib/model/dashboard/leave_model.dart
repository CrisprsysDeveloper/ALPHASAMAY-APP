import 'dart:convert';

class LeaveResponseModel {
  final List<LeaveItem> employeesLeavesList;
  final List<DropdownItem> employeesList;
  final List<LeaveScreenControl> leaveScreenCntrlsList;
  final List<DropdownItem> yearsList;
  final List<DropdownItem> monthsList;
  final String authType;
  final String employeeNo;

  LeaveResponseModel({
    required this.employeesLeavesList,
    required this.employeesList,
    required this.leaveScreenCntrlsList,
    required this.yearsList,
    required this.monthsList,
    required this.authType,
    required this.employeeNo,
  });

  factory LeaveResponseModel.fromJson(Map<String, dynamic> json) {
    return LeaveResponseModel(
      employeesLeavesList: (json['EmployeesLeavesList'] as List)
          .map((e) => LeaveItem.fromJson(e))
          .toList(),
      employeesList: (json['EmployeesList'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      leaveScreenCntrlsList: (json['LeaveScreenCntrlsList'] as List)
          .map((e) => LeaveScreenControl.fromJson(e))
          .toList(),
      yearsList: (json['YearsList'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      monthsList: (json['MonthsList'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      authType: json['AuthType'] ?? '',
      employeeNo: json['EmployeeNo'] ?? '',
    );
  }
}

class LeaveItem {
  final String leaveID;
  final String empName;
  final String position;
  final String department;
  final String costCenter;
  final String project;
  final bool isAdvanceLeave;
  final String leaveStartDate;
  final String leaveEndDate;
  final String leaveType;
  final String leaveTypeDesc;
  final String leaveStatus;
  final String leaveReason;
  final String? blockedQuota;

  LeaveItem({
    required this.leaveID,
    required this.empName,
    required this.position,
    required this.department,
    required this.costCenter,
    required this.project,
    required this.isAdvanceLeave,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.leaveType,
    required this.leaveTypeDesc,
    required this.leaveStatus,
    required this.leaveReason,
    required this.blockedQuota,
  });

  factory LeaveItem.fromJson(Map<String, dynamic> json) {
    return LeaveItem(
      leaveID: json['LeaveID'] ?? '',
      empName: json['EmpName'] ?? '',
      position: json['Position'] ?? '',
      department: json['Department'] ?? '',
      costCenter: json['CostCenter'] ?? '',
      project: json['Project'] ?? '',
      isAdvanceLeave: json['IsAdvanceLeave'] ?? false,
      leaveStartDate: json['LeaveStartDate'] ?? '',
      leaveEndDate: json['LeaveEndDate'] ?? '',
      leaveType: json['LeaveType'] ?? '',
      leaveTypeDesc: json['LeaveTypeDesc'] ?? '',
      leaveStatus: json['LeaveStatus'] ?? '',
      leaveReason: json['LeaveReason'] ?? '',
      blockedQuota: json['BlockedQuota'],
    );
  }
}

class DropdownItem {
  final String id;
  final String value;
  final bool defaultValue;

  DropdownItem({
    required this.id,
    required this.value,
    required this.defaultValue,
  });

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      id: json['ID'] ?? '',
      value: json['Value'] ?? '',
      defaultValue: json['DefaultValue'] ?? false,
    );
  }
}

class LeaveScreenControl {
  final String control;
  final String icon;
  final String modeName;
  final String controlCode;
  final int controlID;

  LeaveScreenControl({
    required this.control,
    required this.icon,
    required this.modeName,
    required this.controlCode,
    required this.controlID,
  });

  factory LeaveScreenControl.fromJson(Map<String, dynamic> json) {
    return LeaveScreenControl(
      control: json['Control'] ?? '',
      icon: json['Icon'] ?? '',
      modeName: json['ModeName'] ?? '',
      controlCode: json['ControlCode'] ?? '',
      controlID: json['ControlID'] ?? 0,
    );
  }
}

