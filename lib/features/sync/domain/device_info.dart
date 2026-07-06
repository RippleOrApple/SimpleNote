class DeviceInfo {
  const DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.appVersion,
  });

  final String deviceId;
  final String deviceName;
  final String platform;
  final String appVersion;

  Map<String, Object?> toJson() => {
        'deviceId': deviceId,
        'deviceName': deviceName,
        'platform': platform,
        'appVersion': appVersion,
      };

  factory DeviceInfo.fromJson(Map<String, Object?> json) {
    return DeviceInfo(
      deviceId: json['deviceId']! as String,
      deviceName: json['deviceName']! as String,
      platform: json['platform']! as String,
      appVersion: json['appVersion']! as String,
    );
  }
}
