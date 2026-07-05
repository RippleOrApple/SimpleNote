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
}
