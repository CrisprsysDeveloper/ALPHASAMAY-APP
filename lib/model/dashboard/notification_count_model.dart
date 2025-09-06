class NotificationCountResponse {
  final String message;
  final String status;
  final String actionType;
  final String objectStatus;
  final String targetUrl;
  final String targetMode;
  final String targetStatus;
  final List<TaskData> data;

  NotificationCountResponse({
    this.message = "",
    this.status = "",
    this.actionType = "",
    this.objectStatus = "",
    this.targetUrl = "",
    this.targetMode = "",
    this.targetStatus = "",
    this.data = const [],
  });

  factory NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    return NotificationCountResponse(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      actionType: json['ActionType'] ?? "",
      objectStatus: json['ObjectStatus'] ?? "",
      targetUrl: json['TargetUrl'] ?? "",
      targetMode: json['TargetMode'] ?? "",
      targetStatus: json['TargetStatus'] ?? "",
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TaskData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class TaskData {
  final String objNavigationRules;
  final String listTasks;
  final String listTaskResultStatus;
  final String listMembers;
  final String targetObj;
  final String message;
  final String count;

  TaskData({
    this.objNavigationRules = "",
    this.listTasks = "",
    this.listTaskResultStatus = "",
    this.listMembers = "",
    this.targetObj = "",
    this.message = "",
    this.count = "",
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      objNavigationRules: json['ObjNavigationRules'] ?? "",
      listTasks: json['listTasks'] ?? "",
      listTaskResultStatus: json['listTaskResultStatus'] ?? "",
      listMembers: json['listMembers'] ?? "",
      targetObj: json['TargetObj'] ?? "",
      message: json['Message'] ?? "",
      count: json['Count'] ?? "",
    );
  }
}

