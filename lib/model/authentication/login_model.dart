
class AuthorizedApplication {
  final String applicationCode;
  final String applicationName;
  final String defaultApp;

  AuthorizedApplication({
    required this.applicationCode,
    required this.applicationName,
    required this.defaultApp,
  });

  factory AuthorizedApplication.fromJson(Map<String, dynamic> json) {
    return AuthorizedApplication(
      applicationCode: json['ApplicationCode'],
      applicationName: json['ApplicationName'],
      defaultApp: json['DefaultApp'],
    );
  }
}

class AuthorizedComponent {
  final String componentCode;
  final String applicationCode;
  final String componentName;
  final String mainMenu;
  final String url;

  AuthorizedComponent({
    required this.componentCode,
    required this.applicationCode,
    required this.componentName,
    required this.mainMenu,
    required this.url,
  });

  factory AuthorizedComponent.fromJson(Map<String, dynamic> json) {
    return AuthorizedComponent(
      componentCode: json['ComponentCode'],
      applicationCode: json['ApplicationCode'],
      componentName: json['ComponentName'],
      mainMenu: json['MainMenu'],
      url: json['URL'],
    );
  }
}

class AuthorizedBusinessObject {
  final String busObjectCode;
  final String busObjectName;
  final String componentCode;

  AuthorizedBusinessObject({
    required this.busObjectCode,
    required this.busObjectName,
    required this.componentCode,
  });

  factory AuthorizedBusinessObject.fromJson(Map<String, dynamic> json) {
    return AuthorizedBusinessObject(
      busObjectCode: json['BusObjectCode'],
      busObjectName: json['BusObjectName'],
      componentCode: json['ComponentCode'],
    );
  }
}

