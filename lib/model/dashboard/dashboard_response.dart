import 'dart:convert';

class DashboardResponse {
  final String message;
  final String messageCode;
  final List<DashboardTile> listOfDashboardQueries;
  final List<DashboardFrameTitle> listOfFrameTitlesList;
  final String dashboardColour;
  final String timeEventsButtonStatus;

  DashboardResponse({
    required this.message,
    required this.messageCode,
    required this.listOfDashboardQueries,
    required this.listOfFrameTitlesList,
    required this.dashboardColour,
    required this.timeEventsButtonStatus,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      message: json['Message'] ?? '',
      messageCode: json['MessageCode'] ?? '',
      listOfDashboardQueries: (json['listofDashboardQueries'] as List? ?? [])
          .map((e) => DashboardTile.fromJson(e))
          .toList(),
      listOfFrameTitlesList: (json['ListOfFrameTitlesList'] as List? ?? [])
          .map((e) => DashboardFrameTitle.fromJson(e))
          .toList(),
      dashboardColour: json['DashboardColour'] ?? '',
      timeEventsButtonStatus: json['TimeEventsButtonStatus'] ?? '',
    );
  }
}

class DashboardTile {
  final String userDbId;
  final String dashboardName;
  final String frameCode;
  final String tileCode;
  final String tileBgColor;
  final String textColor;
  final String typeOfReport;
  final String sourceType;
  final String appCode;
  final String graphId;
  final String queryName;
  final String countBy;
  final String countByField;
  final String queryGroupByField;
  final String queryGroupByField1;
  final String dateGroupByValue;
  final String navigationTargetBusObject;
  final String countByFieldValue;
  final String fieldBusObjCode;
  final String queryReportFields;
  final String createdDate;
  final String updatedDate;
  final String query;
  final String tileName;
  final String groupByFlag;
  final String actualFrameCode;
  final String tileType;
  final String iframeUrl;

  final List<dynamic> queryResult;

  DashboardTile({
    required this.userDbId,
    required this.dashboardName,
    required this.frameCode,
    required this.tileCode,
    required this.tileBgColor,
    required this.textColor,
    required this.typeOfReport,
    required this.sourceType,
    required this.appCode,
    required this.graphId,
    required this.queryName,
    required this.countBy,
    required this.countByField,
    required this.queryGroupByField,
    required this.queryGroupByField1,
    required this.dateGroupByValue,
    required this.navigationTargetBusObject,
    required this.countByFieldValue,
    required this.fieldBusObjCode,
    required this.queryReportFields,
    required this.createdDate,
    required this.updatedDate,
    required this.query,
    required this.queryResult,
    required this.tileName,
    required this.groupByFlag,
    required this.actualFrameCode,
    required this.tileType,
    required this.iframeUrl,
  });

  factory DashboardTile.fromJson(Map<String, dynamic> json) {
    List<dynamic> parsedQueryResult = [];
    try {
      parsedQueryResult = jsonDecode(json['QueryResult'] ?? '[]');
    } catch (_) {
      parsedQueryResult = [];
    }

    return DashboardTile(
      userDbId: json['USERDBID'] ?? '',
      dashboardName: json['DashboardName'] ?? '',
      frameCode: json['FrameCode'] ?? '',
      tileCode: json['TileCode'] ?? '',
      tileBgColor: json['TileBGColor'] ?? '',
      textColor: json['TextColor'] ?? '',
      typeOfReport: json['TypeOfReport'] ?? '',
      sourceType: json['SourceType'] ?? '',
      appCode: json['AppCode'] ?? '',
      graphId: json['GraphID'] ?? '',
      queryName: json['QueryName'] ?? '',
      countBy: json['CountBy'] ?? '',
      countByField: json['CountByField'] ?? '',
      queryGroupByField: json['QueryGroupByField'] ?? '',
      queryGroupByField1: json['QueryGroupByField1'] ?? '',
      dateGroupByValue: json['DateGroupByValue'] ?? '',
      navigationTargetBusObject: json['NavigationTargetBusObject'] ?? '',
      countByFieldValue: json['CountByFieldValue'] ?? '',
      fieldBusObjCode: json['FieldBusObjCode'] ?? '',
      queryReportFields: json['QueryReportFields'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
      updatedDate: json['UpdatedDate'] ?? '',
      query: json['Query'] ?? '',
      queryResult: parsedQueryResult,
      tileName: json['TileName'] ?? '',
      groupByFlag: json['GroupByFlag'] ?? '',
      actualFrameCode: json['ActualFrameCode'] ?? '',
      tileType: json['TileType'] ?? '',
      iframeUrl: json['IFrameUrl'] ?? '',
    );
  }
}

class DashboardFrameTitle {
  final String titleName;

  DashboardFrameTitle({
    required this.titleName,
  });

  factory DashboardFrameTitle.fromJson(Map<String, dynamic> json) {
    return DashboardFrameTitle(
      titleName: json['TitleName'] ?? '',
    );
  }
}
