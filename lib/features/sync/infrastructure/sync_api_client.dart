import 'dart:convert';
import 'dart:io';

import '../domain/device_info.dart';
import '../domain/sync_result.dart';
import '../domain/sync_snapshot.dart';

class SyncApiClient {
  const SyncApiClient();

  Future<bool> healthCheck(Uri baseUri) async {
    final response = await _getJson(baseUri.replace(path: '/health'));
    return response['status'] == 'ok';
  }

  Future<DeviceInfo> device(Uri baseUri) async {
    final response = await _getJson(baseUri.replace(path: '/device'));
    return DeviceInfo.fromJson(response);
  }

  Future<SyncSnapshot> snapshot(Uri baseUri) async {
    final response = await _getJson(baseUri.replace(path: '/snapshot'));
    return SyncSnapshot.fromJson(response);
  }

  Future<SyncResult> sendSnapshot(
    Uri baseUri,
    SyncSnapshot snapshot,
  ) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(baseUri.replace(path: '/sync'));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(snapshot.toJson()));
      final response = await request.close();
      final body = await utf8.decodeStream(response);
      final json = Map<String, Object?>.from(jsonDecode(body) as Map);
      if (response.statusCode != HttpStatus.ok) {
        return SyncResult.fromJson(json);
      }
      return SyncResult.fromJson(json);
    } finally {
      client.close();
    }
  }

  Future<Map<String, Object?>> _getJson(Uri uri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      final body = await utf8.decodeStream(response);
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(body, uri: uri);
      }
      return Map<String, Object?>.from(jsonDecode(body) as Map);
    } finally {
      client.close();
    }
  }
}
