import 'dart:convert';
import 'dart:io';

import '../../../core/constants/app_constants.dart';
import '../data/sync_repository.dart';
import '../domain/sync_result.dart';
import '../domain/sync_snapshot.dart';

class LocalSyncServer {
  LocalSyncServer(this._repository);

  final SyncRepository _repository;
  HttpServer? _server;

  bool get isRunning => _server != null;
  int? get port => _server?.port;
  InternetAddress? get address => _server?.address;

  Future<InternetAddress> start({
    int port = AppConstants.defaultSyncPort,
  }) async {
    if (_server != null) {
      return _server!.address;
    }
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _server!.listen(_handleRequest);
    return _server!.address;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    try {
      switch ((request.method, request.uri.path)) {
        case ('GET', '/health'):
          await _writeJson(request, {'status': 'ok'});
        case ('GET', '/device'):
          await _writeJson(request, _repository.device.toJson());
        case ('GET', '/snapshot'):
          final snapshot = await _repository.exportSnapshot();
          await _writeJson(request, snapshot.toJson());
        case ('POST', '/sync'):
          final body = await utf8.decodeStream(request);
          final snapshot = SyncSnapshot.fromJson(
            Map<String, Object?>.from(jsonDecode(body) as Map),
          );
          final result = await _repository.mergeSnapshot(snapshot);
          await _writeJson(request, result.toJson());
        default:
          await _writeJson(
            request,
            const SyncResult(
              success: false,
              errorMessage: 'not found',
            ).toJson(),
            statusCode: HttpStatus.notFound,
          );
      }
    } catch (error) {
      await _writeJson(
        request,
        SyncResult(success: false, errorMessage: error.toString()).toJson(),
        statusCode: HttpStatus.badRequest,
      );
    }
  }

  Future<void> _writeJson(
    HttpRequest request,
    Map<String, Object?> payload, {
    int statusCode = HttpStatus.ok,
  }) async {
    request.response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(payload));
    await request.response.close();
  }
}
