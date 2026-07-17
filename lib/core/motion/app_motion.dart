import 'package:flutter/material.dart';

import '../../features/appearance/domain/appearance_presets.dart';

abstract final class AppMotion {
  static const hover = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 220);
  static const expressive = Duration(milliseconds: 340);
  static const reduced = Duration(milliseconds: 90);

  static Duration durationFor(
    MotionLevel level, {
    bool reduceMotion = false,
  }) {
    if (reduceMotion) {
      return reduced;
    }
    return switch (level) {
      MotionLevel.reduced => reduced,
      MotionLevel.natural => standard,
      MotionLevel.expressive => expressive,
    };
  }
}

@immutable
final class AppMotionTheme extends ThemeExtension<AppMotionTheme> {
  const AppMotionTheme({
    required this.hoverDuration,
    required this.controlDuration,
    required this.routeDuration,
  });

  factory AppMotionTheme.fromLevel(
    MotionLevel level, {
    bool reduceMotion = false,
  }) {
    final duration = AppMotion.durationFor(
      level,
      reduceMotion: reduceMotion,
    );
    return AppMotionTheme(
      hoverDuration: reduceMotion || level == MotionLevel.reduced
          ? AppMotion.reduced
          : AppMotion.hover,
      controlDuration: duration,
      routeDuration: duration,
    );
  }

  final Duration hoverDuration;
  final Duration controlDuration;
  final Duration routeDuration;

  @override
  AppMotionTheme copyWith({
    Duration? hoverDuration,
    Duration? controlDuration,
    Duration? routeDuration,
  }) {
    return AppMotionTheme(
      hoverDuration: hoverDuration ?? this.hoverDuration,
      controlDuration: controlDuration ?? this.controlDuration,
      routeDuration: routeDuration ?? this.routeDuration,
    );
  }

  @override
  AppMotionTheme lerp(
    covariant ThemeExtension<AppMotionTheme>? other,
    double t,
  ) {
    if (other is! AppMotionTheme) {
      return this;
    }
    return AppMotionTheme(
      hoverDuration: _lerpDuration(hoverDuration, other.hoverDuration, t),
      controlDuration: _lerpDuration(
        controlDuration,
        other.controlDuration,
        t,
      ),
      routeDuration: _lerpDuration(routeDuration, other.routeDuration, t),
    );
  }
}

Duration _lerpDuration(Duration a, Duration b, double t) {
  return Duration(
    microseconds:
        (a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t).round(),
  );
}
