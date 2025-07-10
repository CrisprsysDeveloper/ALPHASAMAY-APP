import 'dart:convert';

class DeleteMessageModel {
  final String? id;
  final String? message;
  final String? messageText;
  final String? messageType;
  final String? messageCode;
  final String? messagePath;
  final String? targetMode;
  final String? targetUrl;

  DeleteMessageModel({
    this.id,
    this.message,
    this.messageText,
    this.messageType,
    this.messageCode,
    this.messagePath,
    this.targetMode,
    this.targetUrl,
  });

  factory DeleteMessageModel.fromJson(Map<String, dynamic> json) {
    return DeleteMessageModel(
      id: json['ID']?.toString(),
      message: json['Message'],
      messageText: json['MessageText'],
      messageType: json['MessageType'],
      messageCode: json['MessageCode'],
      messagePath: json['MessagePath'],
      targetMode: json['TargetMode'],
      targetUrl: json['TargetUrl'],
    );
  }
}

