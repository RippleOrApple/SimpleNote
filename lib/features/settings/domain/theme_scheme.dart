import 'package:flutter/material.dart';

class AppThemeScheme {
  const AppThemeScheme({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.primaryColor,
    required this.textColor,
    required this.surfaceColor,
    required this.brightness,
    this.isActive = false,
  });

  final String id;
  final String name;
  final Color backgroundColor;
  final Color primaryColor;
  final Color textColor;
  final Color surfaceColor;
  final Brightness brightness;
  final bool isActive;

  AppThemeScheme copyWith({
    String? id,
    String? name,
    Color? backgroundColor,
    Color? primaryColor,
    Color? textColor,
    Color? surfaceColor,
    Brightness? brightness,
    bool? isActive,
  }) {
    return AppThemeScheme(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
      textColor: textColor ?? this.textColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      brightness: brightness ?? this.brightness,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'backgroundColor': backgroundColor.toARGB32(),
        'primaryColor': primaryColor.toARGB32(),
        'textColor': textColor.toARGB32(),
        'surfaceColor': surfaceColor.toARGB32(),
        'brightness': brightness.name,
        'isActive': isActive,
      };

  factory AppThemeScheme.fromJson(Map<String, Object?> json) {
    return AppThemeScheme(
      id: json['id']! as String,
      name: json['name']! as String,
      backgroundColor: Color(json['backgroundColor']! as int),
      primaryColor: Color(json['primaryColor']! as int),
      textColor: Color(json['textColor']! as int),
      surfaceColor: Color(json['surfaceColor']! as int),
      brightness: json['brightness'] == Brightness.dark.name
          ? Brightness.dark
          : Brightness.light,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  static const minimalLight = AppThemeScheme(
    id: 'minimal-light',
    name: '极简浅色',
    backgroundColor: Color(0xFFF8F8F6),
    primaryColor: Color(0xFF4F46E5),
    textColor: Color(0xFF202124),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
    isActive: true,
  );

  static const nightBlack = AppThemeScheme(
    id: 'night-black',
    name: '夜间黑',
    backgroundColor: Color(0xFF111318),
    primaryColor: Color(0xFF8AB4F8),
    textColor: Color(0xFFE8EAED),
    surfaceColor: Color(0xFF1F232B),
    brightness: Brightness.dark,
  );

  static const eyeComfortGreen = AppThemeScheme(
    id: 'eye-comfort-green',
    name: '护眼绿',
    backgroundColor: Color(0xFFF3F8EF),
    primaryColor: Color(0xFF2F6F4E),
    textColor: Color(0xFF203128),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const softPurple = AppThemeScheme(
    id: 'soft-purple',
    name: '柔和紫',
    backgroundColor: Color(0xFFF8F5FF),
    primaryColor: Color(0xFF7C3AED),
    textColor: Color(0xFF2B213A),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const coolGrayBlue = AppThemeScheme(
    id: 'cool-gray-blue',
    name: '冷调灰蓝',
    backgroundColor: Color(0xFFF4F7FA),
    primaryColor: Color(0xFF2563EB),
    textColor: Color(0xFF1F2937),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const presets = [
    minimalLight,
    nightBlack,
    eyeComfortGreen,
    softPurple,
    coolGrayBlue,
  ];
}
