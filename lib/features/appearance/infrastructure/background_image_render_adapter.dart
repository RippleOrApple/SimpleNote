import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'background_image_service.dart';

final backgroundRenderCatalogProvider =
    FutureProvider<BackgroundRenderCatalog>((ref) async {
  final storageCatalog = await ref.watch(backgroundImageCatalogProvider.future);
  return BackgroundRenderCatalog.fromStorage(storageCatalog);
});

final class BackgroundRenderCatalog {
  BackgroundRenderCatalog({
    required Map<String, ImageProvider<Object>> imageProviders,
    required Set<String> unavailableImageIds,
  })  : imageProviders = Map.unmodifiable(imageProviders),
        unavailableImageIds = Set.unmodifiable(unavailableImageIds);

  factory BackgroundRenderCatalog.fromStorage(
    BackgroundImageCatalog catalog,
  ) {
    return BackgroundRenderCatalog(
      imageProviders: {
        for (final image in catalog.availableImages)
          image.id: FileImage(File(image.absolutePath)),
      },
      unavailableImageIds: catalog.unavailableImageIds,
    );
  }

  final Map<String, ImageProvider<Object>> imageProviders;
  final Set<String> unavailableImageIds;
}
