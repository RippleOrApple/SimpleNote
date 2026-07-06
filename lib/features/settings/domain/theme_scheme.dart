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

  static const minimalLight = AppThemeScheme(
    id: 'minimal-light',
    name: 'Minimal Light',
    backgroundColor: Color(0xFFF8F8F6),
    primaryColor: Color(0xFF4F46E5),
    textColor: Color(0xFF202124),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
    isActive: true,
  );

  static const nightBlack = AppThemeScheme(
    id: 'night-black',
    name: 'Night Black',
    backgroundColor: Color(0xFF111318),
    primaryColor: Color(0xFF8AB4F8),
    textColor: Color(0xFFE8EAED),
    surfaceColor: Color(0xFF1F232B),
    brightness: Brightness.dark,
  );

  static const eyeComfortGreen = AppThemeScheme(
    id: 'eye-comfort-green',
    name: 'Eye Comfort Green',
    backgroundColor: Color(0xFFF3F8EF),
    primaryColor: Color(0xFF2F6F4E),
    textColor: Color(0xFF203128),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const softPurple = AppThemeScheme(
    id: 'soft-purple',
    name: 'Soft Purple',
    backgroundColor: Color(0xFFF8F5FF),
    primaryColor: Color(0xFF7C3AED),
    textColor: Color(0xFF2B213A),
    surfaceColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const coolGrayBlue = AppThemeScheme(
    id: 'cool-gray-blue',
    name: 'Cool Gray Blue',
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
