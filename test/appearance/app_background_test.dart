import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/core/accessibility/transparency_preference.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/device_appearance_profile.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/shared/widgets/app_background.dart';
import 'package:simple_note/shared/widgets/frosted_surface.dart';

void main() {
  test('maps normalized crop focus to Flutter alignment', () {
    expect(
      AppBackground.focusAlignment(0, 0),
      Alignment.topLeft,
    );
    expect(
      AppBackground.focusAlignment(0.5, 0.5),
      Alignment.center,
    );
    expect(
      AppBackground.focusAlignment(1, 1),
      Alignment.bottomRight,
    );
  });

  testWidgets('renders pure and bundled backgrounds', (tester) async {
    final defaults = AppearanceSettings.defaults();
    final profile = _profile();

    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: defaults,
          deviceProfile: profile,
          brightness: Brightness.light,
          child: const Text('content'),
        ),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color == defaults.lastPureBackground.toColor(),
      ),
      findsOneWidget,
    );

    const assetPath = 'assets/backgrounds/presets/mist-morning.png';
    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: defaults.copyWith(
            background: BackgroundSelection.bundledImage(assetPath),
          ),
          deviceProfile: profile,
          brightness: Brightness.light,
          child: const Text('content'),
        ),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
    expect((image.image as AssetImage).assetName, assetPath);
    expect(image.fit, BoxFit.cover);
  });

  testWidgets('prefers local render source over synchronized selection',
      (tester) async {
    final pngBytes = Uint8List.fromList(
      img.encodePng(img.Image(width: 1, height: 1)),
    );
    final local = MemoryImage(pngBytes);
    final synced = MemoryImage(pngBytes);
    final settings = AppearanceSettings.defaults().copyWith(
      background: BackgroundSelection.syncedImage('synced'),
      lastPureBackground: const RgbColor(0x123456),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: settings,
          deviceProfile: _profile(localImageId: 'local'),
          imageProviders: {
            'local': local,
            'synced': synced,
          },
          brightness: Brightness.dark,
          child: const Text('content'),
        ),
      ),
    );
    final localImage = tester.widget<Image>(find.byType(Image));
    expect(localImage.image, same(local));
    expect(find.byType(ColorFiltered), findsOneWidget);
  });

  testWidgets('falls back with warnings for missing and undecodable sources',
      (tester) async {
    final settings = AppearanceSettings.defaults().copyWith(
      background: BackgroundSelection.syncedImage('synced'),
      lastPureBackground: const RgbColor(0x123456),
    );
    String? warning;

    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: settings,
          deviceProfile: _profile(),
          unavailableImageIds: const {'synced'},
          brightness: Brightness.light,
          onWarningChanged: (value) => warning = value,
          child: const Text('content'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox && widget.color == const Color(0xFF123456),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('app-background-warning')), findsOneWidget);
    expect(warning, contains('不可用'));

    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: settings,
          deviceProfile: _profile(),
          imageProviders: {
            'synced': MemoryImage(Uint8List.fromList(const [0, 1, 2, 3])),
          },
          brightness: Brightness.light,
          onWarningChanged: (value) => warning = value,
          child: const Text('content'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app-background-warning')), findsOneWidget);
    expect(warning, contains('丢失或损坏'));
  });

  testWidgets('applies blur, zoom and overlays from appearance settings',
      (tester) async {
    final settings = AppearanceSettings.defaults().copyWith(
      background: BackgroundSelection.bundledImage(
        'assets/backgrounds/presets/mist-morning.png',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: settings,
          deviceProfile: _profile(
            blur: 8,
            zoom: 1.6,
            overlay: 0.25,
          ),
          brightness: Brightness.dark,
          child: const Text('content'),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.byType(Transform), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color.a > 0 &&
            widget.color ==
                Colors.black.withValues(
                  alpha: settings.darkOverlay + 0.25,
                ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('frosted surface disables only blur for reduced transparency',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FrostedSurface(
          glassOpacity: 0.6,
          accessibility: AppAccessibilityPolicy(
            reduceMotion: false,
            reduceTransparency: true,
          ),
          child: Text('surface'),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    final decorated = tester.widget<DecoratedBox>(
      find.byKey(const Key('frosted-surface-decoration')),
    );
    final color = (decorated.decoration as BoxDecoration).color!;
    expect(color.a, greaterThan(0));
    expect(color.a, lessThan(1));
  });

  testWidgets('opaque glass is an explicit no-transparency control',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FrostedSurface(
          glassOpacity: 1,
          accessibility: AppAccessibilityPolicy(
            reduceMotion: false,
            reduceTransparency: false,
          ),
          child: Text('surface'),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    final decorated = tester.widget<DecoratedBox>(
      find.byKey(const Key('frosted-surface-decoration')),
    );
    final color = (decorated.decoration as BoxDecoration).color!;
    expect(color.a, 1);
  });

  test('maps MediaQuery accessibility signals explicitly', () {
    final policy = AppAccessibilityPolicy.fromMediaQueryData(
      const MediaQueryData(
        disableAnimations: true,
        highContrast: true,
      ),
      transparencyPreference: const TransparencyPreference.unsupported(),
    );

    expect(policy.reduceMotion, isTrue);
    expect(policy.reduceTransparency, isFalse);
    expect(policy.highContrast, isTrue);
    expect(policy.disableBlur, isTrue);
  });
}

DeviceAppearanceProfile _profile({
  String? localImageId,
  double zoom = 1,
  double blur = 0,
  double overlay = 0,
}) {
  return DeviceAppearanceProfile.defaults(
    id: 'device:windows',
    platform: 'windows',
    updatedAt: 1,
  ).copyWith(
    localBackgroundImageId: localImageId,
    backgroundZoom: zoom,
    backgroundBlur: blur,
    backgroundOverlay: overlay,
  );
}
