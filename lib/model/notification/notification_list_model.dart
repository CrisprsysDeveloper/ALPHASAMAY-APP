class NotificationData {
  final List<ObjUNotification> objUNotification;

  NotificationData({required this.objUNotification});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      objUNotification: (json['ObjUNotification'] as List<dynamic>? ?? [])
          .map((e) => ObjUNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ObjUNotification {
  final String id;
  final String objectNo;
  final String applicationType;
  final String applicationID;
  final String notificationType;
  final String empID;
  final String email;
  final bool mailStatus;
  final String mailDelivery;
  final String processingLevel;
  final String status;
  final String notificationStatus;
  final String createdBy;
  final String approvedBy;
  final String approvedDate;
  final String empName;
  final String creatorName;
  final String initiatorName;
  final String to;
  final String cc;
  final String subject;
  final String body;
  final String errorLog;
  final String masterID;
  final bool withApprove;
  final bool readStatus;
  final String agentType;
  final String returnType;
  final String type;
  final String notificationApprovalType;
  final String notificationID;
  final String notificationNo;
  final String appCode;
  final String busObjCode;
  final String senderID;
  final String notification_Type;
  final String notification_Status;
  final String comment;
  final String trafficIndicator;
  final String createdDate;
  final bool readNotification;
  final String trBusinessObject;
  final String trAppCode;
  final String receiverName;
  final String mbleBusObjCode;

  ObjUNotification({
    this.id = '',
    this.objectNo = '',
    this.applicationType = '',
    this.applicationID = '',
    this.notificationType = '',
    this.empID = '',
    this.email = '',
    this.mailStatus = false,
    this.mailDelivery = '',
    this.processingLevel = '',
    this.status = '',
    this.notificationStatus = '',
    this.createdBy = '',
    this.approvedBy = '',
    this.approvedDate = '',
    this.empName = '',
    this.creatorName = '',
    this.initiatorName = '',
    this.to = '',
    this.cc = '',
    this.subject = '',
    this.body = '',
    this.errorLog = '',
    this.masterID = '',
    this.withApprove = false,
    this.readStatus = false,
    this.agentType = '',
    this.returnType = '',
    this.type = '',
    this.notificationApprovalType = '',
    this.notificationID = '',
    this.notificationNo = '',
    this.appCode = '',
    this.busObjCode = '',
    this.senderID = '',
    this.notification_Type = '',
    this.notification_Status = '',
    this.comment = '',
    this.trafficIndicator = '',
    this.createdDate = '',
    this.readNotification = false,
    this.trBusinessObject = '',
    this.trAppCode = '',
    this.receiverName = '',
    this.mbleBusObjCode = '',
  });

  factory ObjUNotification.fromJson(Map<String, dynamic> json) {
    return ObjUNotification(
      id: json['ID']?.toString() ?? '',
      objectNo: json['ObjectNo']?.toString() ?? '',
      applicationType: json['ApplicationType']?.toString() ?? '',
      applicationID: json['ApplicationID']?.toString() ?? '',
      notificationType: json['NotificationType']?.toString() ?? '',
      empID: json['EmpID']?.toString() ?? '',
      email: json['Email']?.toString() ?? '',
      mailStatus: json['MailStatus'] ?? false,
      mailDelivery: json['MailDelivery']?.toString() ?? '',
      processingLevel: json['ProcessingLevel']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
      notificationStatus: json['NotificationStatus']?.toString() ?? '',
      createdBy: json['CreatedBy']?.toString() ?? '',
      approvedBy: json['ApprovedBy']?.toString() ?? '',
      approvedDate: json['ApprovedDate']?.toString() ?? '',
      empName: json['EmpName']?.toString() ?? '',
      creatorName: json['CreatorName']?.toString() ?? '',
      initiatorName: json['InitiatorName']?.toString() ?? '',
      to: json['TO']?.toString() ?? '',
      cc: json['Cc']?.toString() ?? '',
      subject: json['Subject']?.toString() ?? '',
      body: json['Body']?.toString() ?? '',
      errorLog: json['ErrorLog']?.toString() ?? '',
      masterID: json['MasterID']?.toString() ?? '',
      withApprove: json['WithApprove'] ?? false,
      readStatus: json['ReadStatus'] ?? false,
      agentType: json['AgentType']?.toString() ?? '',
      returnType: json['ReturnType']?.toString() ?? '',
      type: json['Type']?.toString() ?? '',
      notificationApprovalType: json['NotificationApprovalType']?.toString() ?? '',
      notificationID: json['Notification_ID']?.toString() ?? '',
      notificationNo: json['Notification_No']?.toString() ?? '',
      appCode: json['AppCode']?.toString() ?? '',
      busObjCode: json['BusObjCode']?.toString() ?? '',
      senderID: json['Sender_ID']?.toString() ?? '',
      notification_Type: json['Notification_Type']?.toString() ?? '',
      notification_Status: json['Notification_Status']?.toString() ?? '',
      comment: json['Comment']?.toString() ?? '',
      trafficIndicator: json['TrafficIndicator']?.toString() ?? '',
      createdDate: json['CREATEDDATE']?.toString() ?? '',
      readNotification: json['ReadNotification'] ?? false,
      trBusinessObject: json['TRBusinessObject']?.toString() ?? '',
      trAppCode: json['TRAppCode']?.toString() ?? '',
      receiverName: json['ReceiverName']?.toString() ?? '',
      mbleBusObjCode: json['MbleBusObjCode']?.toString() ?? '',
    );
  }
}
