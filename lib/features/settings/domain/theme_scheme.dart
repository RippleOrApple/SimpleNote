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
}
