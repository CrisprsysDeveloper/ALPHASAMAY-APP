class LeaveQuotaModel {
  final List<DropdownItem> employeesList;
  final List<DropdownItem> leaveTypesList;
  final List<LeaveQuotaItem> leaveQuotaList;
  final List<DropdownItem> yearList;
  final List<LeaveScreenControl> leaveScreenCntrlsList;
  final String authType;
  final String message;
  final String id;

  LeaveQuotaModel({
    required this.employeesList,
    required this.leaveTypesList,
    required this.leaveQuotaList,
    required this.yearList,
    required this.leaveScreenCntrlsList,
    required this.authType,
    required this.message,
    required this.id,
  });

  factory LeaveQuotaModel.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaModel(
      employeesList: (json['EmployeesList'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      leaveTypesList: (json['LeaveTypesList'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      leaveQuotaList: (json['LeaveQuotaList'] as List)
          .map((e) => LeaveQuotaItem.fromJson(e))
          .toList(),
      yearList: (json['YearList'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      leaveScreenCntrlsList: (json['LeaveScreenCntrlsList'] as List)
          .map((e) => LeaveScreenControl.fromJson(e))
          .toList(),
      authType: json['AuthType'] ?? '',
      message: json['Message'] ?? '',
      id: json['ID'] ?? '',
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
  final String roleID;
  final String modeName;
  final String controlCode;
  final int controlID;
  final String statusDesc;
  final String taskStatus;

  LeaveScreenControl({
    required this.control,
    required this.icon,
    required this.roleID,
    required this.modeName,
    required this.controlCode,
    required this.controlID,
    required this.statusDesc,
    required this.taskStatus,
  });

  factory LeaveScreenControl.fromJson(Map<String, dynamic> json) {
    return LeaveScreenControl(
      control: json['Control'] ?? '',
      icon: json['Icon'] ?? '',
      roleID: json['RoleID'] ?? '',
      modeName: json['ModeName'] ?? '',
      controlCode: json['ControlCode'] ?? '',
      controlID: json['ControlID'] ?? 0,
      statusDesc: json['StatusDesc'] ?? '',
      taskStatus: json['TaskStatus'] ?? '',
    );
  }
}

class LeaveQuotaItem {
  final String qid;
  final String lid;
  final String leaveID;
  final String pernr;
  final String empName;
  final String position;
  final String department;
  final String costCenter;
  final String project;
  final String jobRole;
  final int noOfDays;
  final bool isAdvanceLeave;
  final String leaveStartDate;
  final String leaveEndDate;
  final String leaveType;
  final String leaveTypeDesc;
  final String leaveStatus;
  final String leaveReason;
  final int dateDifference;
  final String message;
  final String quota;
  final String grade;
  final String usedQuota;
  final String actualQuota;
  final String balanceQuota;
  final String blockedQuota;
  final String createdDate;
  final String createdBy;
  final String updatedDate;
  final String modifiedBy;
  final String docsCount;
  final String penaltyDays;
  final String year;
  final String dateMonth;
  final String deptID;
  final String ccntr;
  final String prjnr;
  final String ccode;
  final String userName;

  LeaveQuotaItem({
    required this.qid,
    required this.lid,
    required this.leaveID,
    required this.pernr,
    required this.empName,
    required this.position,
    required this.department,
    required this.costCenter,
    required this.project,
    required this.jobRole,
    required this.noOfDays,
    required this.isAdvanceLeave,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.leaveType,
    required this.leaveTypeDesc,
    required this.leaveStatus,
    required this.leaveReason,
    required this.dateDifference,
    required this.message,
    required this.quota,
    required this.grade,
    required this.usedQuota,
    required this.actualQuota,
    required this.balanceQuota,
    required this.blockedQuota,
    required this.createdDate,
    required this.createdBy,
    required this.updatedDate,
    required this.modifiedBy,
    required this.docsCount,
    required this.penaltyDays,
    required this.year,
    required this.dateMonth,
    required this.deptID,
    required this.ccntr,
    required this.prjnr,
    required this.ccode,
    required this.userName,
  });

  factory LeaveQuotaItem.fromJson(Map<String, dynamic> json) {
    return LeaveQuotaItem(
      qid: json['QID'] ?? '',
      lid: json['LID'] ?? '',
      leaveID: json['LeaveID'] ?? '',
      pernr: json['PERNR'] ?? '',
      empName: json['EmpName'] ?? '',
      position: json['Position'] ?? '',
      department: json['Department'] ?? '',
      costCenter: json['CostCenter'] ?? '',
      project: json['Project'] ?? '',
      jobRole: json['JobRole'] ?? '',
      noOfDays: json['NoOfDays'] ?? 0,
      isAdvanceLeave: json['IsAdvanceLeave'] ?? false,
      leaveStartDate: json['LeaveStartDate'] ?? '',
      leaveEndDate: json['LeaveEndDate'] ?? '',
      leaveType: json['LeaveType'] ?? '',
      leaveTypeDesc: json['LeaveTypeDesc'] ?? '',
      leaveStatus: json['LeaveStatus'] ?? '',
      leaveReason: json['LeaveReason'] ?? '',
      dateDifference: json['DateDifference'] ?? 0,
      message: json['Message'] ?? '',
      quota: json['Quota'] ?? '',
      grade: json['Grade'] ?? '',
      usedQuota: json['UsedQuota'] ?? '',
      actualQuota: json['ActualQuota'] ?? '',
      balanceQuota: json['BalanceQuota'] ?? '',
      blockedQuota: json['BlockedQuota'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
      createdBy: json['CreatedBy'] ?? '',
      updatedDate: json['UpdatedDate'] ?? '',
      modifiedBy: json['ModifiedBy'] ?? '',
      docsCount: json['DocsCount'] ?? '',
      penaltyDays: json['PenaltyDays'] ?? '',
      year: json['Year'] ?? '',
      dateMonth: json['DateMonth'] ?? '',
      deptID: json['DeptID'] ?? '',
      ccntr: json['CCNTR'] ?? '',
      prjnr: json['PRJNR'] ?? '',
      ccode: json['CCODE'] ?? '',
      userName: json['UserName'] ?? '',
    );
  }
}
