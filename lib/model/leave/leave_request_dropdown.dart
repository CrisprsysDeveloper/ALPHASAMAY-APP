class LeaveScreenData {
  List<Employee> employeesList;
  List<LeaveType> leaveTypesList;
  List<dynamic> listOfDayWiseDate;
  List<WorkingDay> workingDayList;
  List<FieldDescription> fieldNameDescriptions;
  String employeeNo;
  String authType;
  String dmsFolder;
  dynamic listDynamicScreenFiledEnables;
  dynamic leaveScreenCntrlsList;

  LeaveScreenData({
    this.employeesList = const [],
    this.leaveTypesList = const [],
    this.listOfDayWiseDate = const [],
    this.workingDayList = const [],
    this.fieldNameDescriptions = const [],
    this.employeeNo = '',
    this.authType = '',
    this.dmsFolder = '',
    this.listDynamicScreenFiledEnables,
    this.leaveScreenCntrlsList,
  });

  factory LeaveScreenData.fromJson(Map<String, dynamic> json) {
    return LeaveScreenData(
      employeesList: (json['EmployeesList'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e))
          .toList() ??
          [],
      leaveTypesList: (json['LeaveTypesList'] as List<dynamic>?)
          ?.map((e) => LeaveType.fromJson(e))
          .toList() ??
          [],
      listOfDayWiseDate: json['ListOfDayWiseDate'] ?? [],
      workingDayList: (json['WorkingDayList'] as List<dynamic>?)
          ?.map((e) => WorkingDay.fromJson(e))
          .toList() ??
          [],
      fieldNameDescriptions: (json['FieldNameDescriptions'] as List<dynamic>?)
          ?.map((e) => FieldDescription.fromJson(e))
          .toList() ??
          [],
      employeeNo: json['EmployeeNo'] ?? '',
      authType: json['AuthType'] ?? '',
      dmsFolder: json['DMSFolder'] ?? '',
      listDynamicScreenFiledEnables: json['listDynamicScreenFiledEnables'],
      leaveScreenCntrlsList: json['LeaveScreenCntrlsList'],
    );
  }
}

class Employee {
  String id;
  String value;
  bool defaultValue;

  Employee({
    this.id = '',
    this.value = '',
    this.defaultValue = false,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['ID'] ?? '',
      value: json['Value'] ?? '',
      defaultValue: json['DefaultValue'] ?? false,
    );
  }
}

class LeaveType {
  String id;
  String value;
  bool defaultValue;

  LeaveType({
    this.id = '',
    this.value = '',
    this.defaultValue = false,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['ID'] ?? '',
      value: json['Value'] ?? '',
      defaultValue: json['DefaultValue'] ?? false,
    );
  }
}

class WorkingDay {
  String workingDayID;
  String workingDayDescription;
  String startOfTheWeek;
  String weekoffdays;
  String createdDate;
  String updatedDate;
  String groupName;

  WorkingDay({
    this.workingDayID = '',
    this.workingDayDescription = '',
    this.startOfTheWeek = '',
    this.weekoffdays = '',
    this.createdDate = '',
    this.updatedDate = '',
    this.groupName = '',
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      workingDayID: json['WorkingDayID'] ?? '',
      workingDayDescription: json['WorkingDayDescription'] ?? '',
      startOfTheWeek: json['StartOfTheWeek'] ?? '',
      weekoffdays: json['Weekoffdays'] ?? '',
      createdDate: json['CREATED_DATE'] ?? '',
      updatedDate: json['UPDATED_DATE'] ?? '',
      groupName: json['GroupName'] ?? '',
    );
  }
}

class FieldDescription {
  String labelName;
  String labelDescription;

  FieldDescription({
    this.labelName = '',
    this.labelDescription = '',
  });

  factory FieldDescription.fromJson(Map<String, dynamic> json) {
    return FieldDescription(
      labelName: json['LabelName'] ?? '',
      labelDescription: json['LabelDescription'] ?? '',
    );
  }
}
