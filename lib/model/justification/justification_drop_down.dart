import 'dart:convert';

class JustificationCreateData {
  final ServiceStatus serviceStatus;
  final List<AuthEmployee> authEmployeesList;
  final List<PartnerType> partnerTypeList;
  final List<ViolationTypeData> violationTypeDataList;
  final List<JustifyScreenControl> justifyScreenCntrlsList;
  final List<WorkingDay> workingDayList;
  final String authJustificationType;
  final List<FieldNameDescription> fieldNameDescriptions;

  JustificationCreateData({
    required this.serviceStatus,
    required this.authEmployeesList,
    required this.partnerTypeList,
    required this.violationTypeDataList,
    required this.justifyScreenCntrlsList,
    required this.workingDayList,
    required this.authJustificationType,
    required this.fieldNameDescriptions,
  });

  factory JustificationCreateData.fromJson(Map<String, dynamic> json) {
    return JustificationCreateData(
      serviceStatus: ServiceStatus.fromJson(
        jsonDecode(json['ServiceStatus'] ?? '{}'),
      ),
      authEmployeesList: _parseJsonList<AuthEmployee>(
        json['AuthEmployeesList'],
        AuthEmployee.fromJson,
      ),
      partnerTypeList: _parseJsonList<PartnerType>(
        json['PartnerTypeList'],
        PartnerType.fromJson,
      ),
      violationTypeDataList: _parseJsonList<ViolationTypeData>(
        json['ViolationTypeDataList'],
        ViolationTypeData.fromJson,
      ),
      justifyScreenCntrlsList: _parseJsonList<JustifyScreenControl>(
        json['JustifyScreenCntrlsList'],
        JustifyScreenControl.fromJson,
      ),
      workingDayList: _parseJsonList<WorkingDay>(
        json['WorkingDayList'],
        WorkingDay.fromJson,
      ),
      authJustificationType: json['AuthJustificationType'] ?? '',
      fieldNameDescriptions:
          (json['FieldNameDescriptions'] as List<dynamic>)
              .map((e) => FieldNameDescription.fromJson(e))
              .toList(),
    );
  }
}

Map<String, dynamic> _parseJsonString(String? jsonStr) {
  return jsonStr != null ? Map<String, dynamic>.from(jsonDecode(jsonStr)) : {};
}

List<T> _parseJsonList<T>(
  String? jsonStr,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (jsonStr == null || jsonStr.isEmpty) return [];
  final List<dynamic> list = jsonDecode(jsonStr);
  return list.map((item) => fromJson(item)).toList();
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

class AuthEmployee {
  final String id;
  final String description;
  final String pType;
  final String prjnr;
  final String deptId;
  final String ccode;

  AuthEmployee({
    required this.id,
    required this.description,
    required this.pType,
    required this.prjnr,
    required this.deptId,
    required this.ccode,
  });

  factory AuthEmployee.fromJson(Map<String, dynamic> json) {
    return AuthEmployee(
      id: json['ID'] ?? '',
      description: json['Description'] ?? '',
      pType: json['PType'] ?? '',
      prjnr: json['PRJNR'] ?? '',
      deptId: json['DeptID'] ?? '',
      ccode: json['CCODE'] ?? '',
    );
  }
}

class PartnerType {
  final String id;
  final String value;

  PartnerType({required this.id, required this.value});

  factory PartnerType.fromJson(Map<String, dynamic> json) {
    return PartnerType(
      id: json['Id'] ?? '',
      value: json['Value'] ?? '',
    );
  }
}


class ViolationTypeData {
  final String id;
  final String value;
  final String defaultValue;

  ViolationTypeData({
    required this.id,
    required this.value,
    required this.defaultValue,
  });

  factory ViolationTypeData.fromJson(Map<String, dynamic> json) {
    return ViolationTypeData(
      id: json['Id'] ?? '',
      value: json['Value'] ?? '',
      defaultValue: json['DefaultValue'] ?? '',
    );
  }
}

class JustifyScreenControl {
  final String control;
  final String icon;
  final String modeName;
  final String controlCode;
  final int controlID;

  JustifyScreenControl({
    required this.control,
    required this.icon,
    required this.modeName,
    required this.controlCode,
    required this.controlID,
  });

  factory JustifyScreenControl.fromJson(Map<String, dynamic> json) {
    return JustifyScreenControl(
      control: json['Control'] ?? '',
      icon: json['Icon'] ?? '',
      modeName: json['ModeName'] ?? '',
      controlCode: json['ControlCode'] ?? '',
      controlID: json['ControlID'] ?? 0,
    );
  }
}

class WorkingDay {
  final String startOfTheWeek;
  final String workingDayID;
  final String weekoffdays;

  WorkingDay({
    required this.startOfTheWeek,
    required this.workingDayID,
    required this.weekoffdays,
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      startOfTheWeek: json['StartOfTheWeek'] ?? '',
      workingDayID: json['WorkingDayID'] ?? '',
      weekoffdays: json['Weekoffdays'] ?? '',
    );
  }
}

class FieldNameDescription {
  final String labelName;
  final String labelDescription;

  FieldNameDescription({
    required this.labelName,
    required this.labelDescription,
  });

  factory FieldNameDescription.fromJson(Map<String, dynamic> json) {
    return FieldNameDescription(
      labelName: json['LabelName'] ?? '',
      labelDescription: json['LabelDescription'] ?? '',
    );
  }
}
