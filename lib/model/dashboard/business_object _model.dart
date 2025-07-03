import 'dart:convert';

class BusinessObject {
  final String id;
  final String value;

  BusinessObject({required this.id, required this.value});

  factory BusinessObject.fromJson(Map<String, dynamic> json) =>
      BusinessObject(id: json['ID'], value: json['Value']);
}

class AttendanceUser {
  final String id;
  final String description;
  final String pType;

  AttendanceUser({
    required this.id,
    required this.description,
    required this.pType,
  });

  factory AttendanceUser.fromJson(Map<String, dynamic> json) => AttendanceUser(
    id: json['ID'],
    description: json['Description'],
    pType: json['PType'],
  );
}
