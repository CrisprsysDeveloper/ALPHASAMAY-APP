class UserSettingsModel {
  final String? crisprsysTimeZone;
  final String? clientTimeZone;
  final String? userTimeZone;
  final String? crisprsysDateFormat;
  final String? userDateFormat;
  final String? numberFormat;
  final bool? userDefaultAdvanceSettings;

  UserSettingsModel({
    this.crisprsysTimeZone,
    this.clientTimeZone,
    this.userTimeZone,
    this.crisprsysDateFormat,
    this.userDateFormat,
    this.numberFormat,
    this.userDefaultAdvanceSettings,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      crisprsysTimeZone: json['CrisprsysTimeZone'],
      clientTimeZone: json['ClientTimeZone'],
      userTimeZone: json['UserTimeZone'],
      crisprsysDateFormat: json['CrisprsysDateFormat'],
      userDateFormat: json['UserDateFormat'],
      numberFormat: json['NumberFormat'],
      userDefaultAdvanceSettings: json['UserDefaultAdvanceSettings'],
    );
  }
}
