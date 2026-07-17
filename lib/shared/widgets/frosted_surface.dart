import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
final class AppAccessibilityPolicy {
  const AppAccessibilityPolicy({
    required this.reduceMotion,
    required this.reduceTransparency,
  });

  factory AppAccessibilityPolicy.fromMediaQueryData(MediaQueryData data) {
    return AppAccessibilityPolicy(
      reduceMotion: data.disableAnimations,
      reduceTransparency: data.highContrast,
    );
  }

  factory AppAccessibilityPolicy.of(BuildContext context) {
    return AppAccessibilityPolicy.fromMediaQueryData(MediaQuery.of(context));
  }

  final bool reduceMotion;
  final bool reduceTransparency;
}

class FrostedSurface extends StatelessWidget {
  const FrostedSurface({
    required this.child,
    required this.glassOpacity,
    super.key,
    this.blurSigma = 18,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding,
    this.surfaceColor,
    this.borderColor,
    this.accessibility,
  });

  final Widget child;
  final double glassOpacity;
  final double blurSigma;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? surfaceColor;
  final Color? borderColor;
  final AppAccessibilityPolicy? accessibility;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final policy = accessibility ?? AppAccessibilityPolicy.of(context);
    final effectiveOpacity = glassOpacity.clamp(0.0, 1.0);
    final decoration = BoxDecoration(
      color: (surfaceColor ?? theme.colorScheme.surface).withValues(
        alpha: effectiveOpacity,
      ),
      border: Border.all(
        color:
            borderColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.14),
      ),
      borderRadius: borderRadius,
    );
    final decorated = DecoratedBox(
      key: const Key('frosted-surface-decoration'),
      decoration: decoration,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: policy.reduceTransparency || blurSigma <= 0
          ? decorated
          : BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
              ),
              child: decorated,
            ),
    );
  }
}
