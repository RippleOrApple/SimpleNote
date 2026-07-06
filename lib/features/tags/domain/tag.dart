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

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
      };

  factory Tag.fromJson(Map<String, Object?> json) {
    return Tag(
      id: json['id']! as String,
      name: json['name']! as String,
      color: json['color'] as String?,
      createdAt: json['createdAt']! as int,
      updatedAt: json['updatedAt']! as int,
      deletedAt: json['deletedAt'] as int?,
      deviceId: json['deviceId']! as String,
    );
  }
}
