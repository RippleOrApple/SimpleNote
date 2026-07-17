import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/background_image.dart';
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

  testWidgets('prefers local image and falls back when image is missing',
      (tester) async {
    final directory = Directory.systemTemp.createTempSync(
      'simple-note-background-widget-',
    );
    addTearDown(() => directory.deleteSync(recursive: true));
    final pngBytes = img.encodePng(img.Image(width: 1, height: 1));
    expect(
      img.decodePng(pngBytes),
      isNotNull,
      reason: 'The fixture must be a decodable PNG before Flutter reads it.',
    );
    final localFile =
        File('${directory.path}${Platform.pathSeparator}local.png')
          ..writeAsBytesSync(pngBytes);
    final local = _image(id: 'local', absolutePath: localFile.path);
    final synced = _image(
      id: 'synced',
      absolutePath: '${directory.path}${Platform.pathSeparator}missing.png',
    );
    final settings = AppearanceSettings.defaults().copyWith(
      background: BackgroundSelection.syncedImage('synced'),
      lastPureBackground: const RgbColor(0x123456),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: settings,
          deviceProfile: _profile(localImageId: 'local'),
          backgroundImages: [local, synced],
          brightness: Brightness.dark,
          child: const Text('content'),
        ),
      ),
    );
    final localImage = tester.widget<Image>(find.byType(Image));
    expect((localImage.image as FileImage).file.path, localFile.path);
    expect(find.byType(ColorFiltered), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: AppBackground(
          settings: settings,
          deviceProfile: _profile(),
          backgroundImages: [synced],
          unavailableImageIds: const {'synced'},
          brightness: Brightness.light,
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

  test('maps MediaQuery accessibility signals explicitly', () {
    final policy = AppAccessibilityPolicy.fromMediaQueryData(
      const MediaQueryData(
        disableAnimations: true,
        highContrast: true,
      ),
    );

    expect(policy.reduceMotion, isTrue);
    expect(policy.reduceTransparency, isTrue);
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

BackgroundImage _image({
  required String id,
  required String absolutePath,
}) {
  return BackgroundImage(
    id: id,
    sha256: '0000000000000000000000000000000000000000000000000000000000000000',
    mimeType: 'image/png',
    byteSize: 1,
    width: 1,
    height: 1,
    relativePath: 'backgrounds/$id.png',
    absolutePath: absolutePath,
    syncEnabled: id == 'synced',
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
    version: 1,
  );
}
