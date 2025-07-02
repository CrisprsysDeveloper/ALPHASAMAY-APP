import 'dart:convert';

class AuthResponseModel {
  final ServiceStatus serviceStatus;
  final List<AuthObject> authBasedObjectsList;
  final List<CheckType> checkTypeList;
  final List<PartnerType> partnerTypeList;
  final String employeeNumber;
  final String authEventType;
  final String currentDateTime;
  final List<ProjectItem> projectsList;

  AuthResponseModel({
    required this.serviceStatus,
    required this.authBasedObjectsList,
    required this.checkTypeList,
    required this.partnerTypeList,
    required this.employeeNumber,
    required this.authEventType,
    required this.currentDateTime,
    required this.projectsList,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      serviceStatus: ServiceStatus.fromJson(jsonDecode(json['ServiceStatus'])),
      authBasedObjectsList:
          (jsonDecode(json['AuthBasedObjectsList']) as List)
              .map((e) => AuthObject.fromJson(e))
              .toList(),
      checkTypeList:
          (jsonDecode(json['CheckTypeList']) as List)
              .map((e) => CheckType.fromJson(e))
              .toList(),
      partnerTypeList:
          (json['PartnerTypeList'] as List)
              .map((e) => PartnerType.fromJson(e))
              .toList(),
      employeeNumber: json['EmployeeNumber'] ?? '',
      authEventType: json['AuthEventType'] ?? '',
      currentDateTime: json['CurrentDateTime'] ?? '',
      projectsList:
          (json['ProjectsList'] as List)
              .map((e) => ProjectItem.fromJson(e))
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
      messageCode: json['MessageCode'] ?? '',
      messageDescription: json['MessageDescription'] ?? '',
    );
  }
}

class AuthObject {
  final String id;
  final String description;
  final String pType;
  final String? prjnr;
  final String? deptId;
  final String ccode;

  AuthObject({
    required this.id,
    required this.description,
    required this.pType,
    this.prjnr,
    this.deptId,
    required this.ccode,
  });

  factory AuthObject.fromJson(Map<String, dynamic> json) {
    return AuthObject(
      id: json['ID'] ?? '',
      description: json['Description'] ?? '',
      pType: json['PType'] ?? '',
      prjnr: json['PRJNR'],
      deptId: json['DeptID'],
      ccode: json['CCODE'] ?? '',
    );
  }
}

class CheckType {
  final String id;
  final String value;

  CheckType({required this.id, required this.value});

  factory CheckType.fromJson(Map<String, dynamic> json) {
    return CheckType(id: json['Id'] ?? '', value: json['Value'] ?? '');
  }
}

class PartnerType {
  final String id;
  final String value;
  final bool defaultValue;

  PartnerType({
    required this.id,
    required this.value,
    required this.defaultValue,
  });

  factory PartnerType.fromJson(Map<String, dynamic> json) {
    return PartnerType(
      id: json['ID'] ?? '',
      value: json['Value'] ?? '',
      defaultValue: json['DefaultValue'] ?? false,
    );
  }
}

class ProjectItem {
  final String id;
  final String value;
  final bool defaultValue;

  ProjectItem({
    required this.id,
    required this.value,
    required this.defaultValue,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['ID'] ?? '',
      value: json['Value'] ?? '',
      defaultValue: json['DefaultValue'] ?? false,
    );
  }
}
