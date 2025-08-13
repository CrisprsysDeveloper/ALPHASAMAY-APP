class JustificationResponse {
  final String dummyID;
  final String actualResponse;
  final String presentLeaveStatus;
  final String validationResponse;
  final bool isValidation;
  final List<TeamMember> teamMembersList;

  JustificationResponse({
    this.dummyID = '',
    this.actualResponse = '',
    this.presentLeaveStatus = '',
    this.validationResponse = '',
    this.isValidation = false,
    this.teamMembersList = const [],
  });

  factory JustificationResponse.fromJson(Map<String, dynamic> json) {
    return JustificationResponse(
      dummyID: json['DummyID'] ?? '',
      actualResponse: json['ActualResponse'] ?? '',
      presentLeaveStatus: json['PresentLeaveStatus'] ?? '',
      validationResponse: json['ValidationResponse'] ?? '',
      isValidation: json['IsValidation'] ?? false,
      teamMembersList:
          (json['TeamMembersList'] as List<dynamic>?)
              ?.map((e) => TeamMember.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TeamMember {
  final String teamMemID;
  final String dummyJustID;
  final String appCode;
  final String objectNo;
  final String memberType;
  final String memberID;
  final String level;
  final String actionType;
  final String actionTypeDesc;
  final String memStatus;
  final String memStatusNames;
  final String createdBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;
  final String memberName;
  final String name;
  final String contactNo;
  final String emailID;
  final String color;
  final String sequence;
  final String taskGroupID;
  final String agentCategory;
  final String approvalReq;
  final String workflowID;
  final String stepLevel;
  final bool isCompletedApproval;
  final bool chooseBusObjFlag;
  final String id;
  final String taskID;
  final String company;
  final String updates;
  final String authorization;
  final bool approved;
  final bool rejected;
  final bool closeApproved;
  final bool closeRejected;
  final String hdStatus;
  final String getTaskDetails;
  final String notificationApprovalType;
  final String dummyMemStatus;
  final String notificationID;
  final String bgActionType;
  final String memberActionType;

  TeamMember({
    this.teamMemID = '',
    this.dummyJustID = '',
    this.appCode = '',
    this.objectNo = '',
    this.memberType = '',
    this.memberID = '',
    this.level = '',
    this.actionType = '',
    this.actionTypeDesc = '',
    this.memStatus = '',
    this.memStatusNames = '',
    this.createdBy = '',
    this.createdDate = '',
    this.modifiedBy = '',
    this.modifiedDate = '',
    this.memberName = '',
    this.name = '',
    this.contactNo = '',
    this.emailID = '',
    this.color = '',
    this.sequence = '',
    this.taskGroupID = '',
    this.agentCategory = '',
    this.approvalReq = '',
    this.workflowID = '',
    this.stepLevel = '',
    this.isCompletedApproval = false,
    this.chooseBusObjFlag = false,
    this.id = '',
    this.taskID = '',
    this.company = '',
    this.updates = '',
    this.authorization = '',
    this.approved = false,
    this.rejected = false,
    this.closeApproved = false,
    this.closeRejected = false,
    this.hdStatus = '',
    this.getTaskDetails = '',
    this.notificationApprovalType = '',
    this.dummyMemStatus = '',
    this.notificationID = '',
    this.bgActionType = '',
    this.memberActionType = '',
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      teamMemID: json['TeamMemID'] ?? '',
      dummyJustID: json['DummyJustID'] ?? '',
      appCode: json['AppCode'] ?? '',
      objectNo: json['ObjectNo'] ?? '',
      memberType: json['MemberType'] ?? '',
      memberID: json['MemberID'] ?? '',
      level: json['Level'] ?? '',
      actionType: json['ActionType'] ?? '',
      actionTypeDesc: json['ActionTypeDesc'] ?? '',
      memStatus: json['Mem_Status'] ?? '',
      memStatusNames: json['Mem_StatusNames'] ?? '',
      createdBy: json['CreatedBy'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
      modifiedBy: json['ModifiedBy'] ?? '',
      modifiedDate: json['ModifiedDate'] ?? '',
      memberName: json['MemberName'] ?? '',
      name: json['Name'] ?? '',
      contactNo: json['ContactNo'] ?? '',
      emailID: json['EmailID'] ?? '',
      color: json['Color'] ?? '',
      sequence: json['Sequence'] ?? '',
      taskGroupID: json['TaskGroupID'] ?? '',
      agentCategory: json['Agent_Category'] ?? '',
      approvalReq: json['ApprovalReq'] ?? '',
      workflowID: json['WorkflowID'] ?? '',
      stepLevel: json['StepLevel'] ?? '',
      isCompletedApproval: json['IsCompletedApproval'] ?? false,
      chooseBusObjFlag: json['ChooseBusObjflag'] ?? false,
      id: json['ID'] ?? '',
      taskID: json['TaskID'] ?? '',
      company: json['Company'] ?? '',
      updates: json['Updates'] ?? '',
      authorization: json['Authorization'] ?? '',
      approved: json['Approved'] ?? false,
      rejected: json['Rejected'] ?? false,
      closeApproved: json['CloseApproved'] ?? false,
      closeRejected: json['CloseRejected'] ?? false,
      hdStatus: json['HDStatus'] ?? '',
      getTaskDetails: json['GetTaskDetails'] ?? '',
      notificationApprovalType: json['NotificationApprovalType'] ?? '',
      dummyMemStatus: json['DummyMem_Status'] ?? '',
      notificationID: json['Notification_ID'] ?? '',
      bgActionType: json['BGActionType'] ?? '',
      memberActionType: json['MemberActionType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TeamMemID': teamMemID,
      'DummyJustID': dummyJustID,
      'AppCode': appCode,
      'ObjectNo': objectNo,
      'MemberType': memberType,
      'MemberID': memberID,
      'Level': level,
      'ActionType': actionType,
      'ActionTypeDesc': actionTypeDesc,
      'Mem_Status': memStatus,
      'Mem_StatusNames': memStatusNames,
      'CreatedBy': createdBy,
      'CreatedDate': createdDate,
      'ModifiedBy': modifiedBy,
      'ModifiedDate': modifiedDate,
      'MemberName': memberName,
      'Name': name,
      'ContactNo': contactNo,
      'EmailID': emailID,
      'Color': color,
      'Sequence': sequence,
      'TaskGroupID': taskGroupID,
      'Agent_Category': agentCategory,
      'ApprovalReq': approvalReq,
      'WorkflowID': workflowID,
      'StepLevel': stepLevel,
      'IsCompletedApproval': isCompletedApproval,
      'ChooseBusObjflag': chooseBusObjFlag,
      'ID': id,
      'TaskID': taskID,
      'Company': company,
      'Updates': updates,
      'Authorization': authorization,
      'Approved': approved,
      'Rejected': rejected,
      'CloseApproved': closeApproved,
      'CloseRejected': closeRejected,
      'HDStatus': hdStatus,
      'GetTaskDetails': getTaskDetails,
      'NotificationApprovalType': notificationApprovalType,
      'DummyMem_Status': dummyMemStatus,
      'Notification_ID': notificationID,
      'BGActionType': bgActionType,
      'MemberActionType': memberActionType,
    };
  }
}
