class Tag {
  const Tag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.color,
    this.deletedAt,
  });

  final String id;
  final String name;
  final String? color;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
}
