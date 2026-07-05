import 'dart:io';

import '../../../core/constants/app_constants.dart';

class LocalSyncServer {
  HttpServer? _server;

  bool get isRunning => _server != null;

  Future<InternetAddress> start(
      {int port = AppConstants.defaultSyncPort}) async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _server!.listen(_handleRequest);
    return _server!.address;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  void _handleRequest(HttpRequest request) {
    if (request.uri.path == '/health') {
      request.response
        ..statusCode = HttpStatus.ok
        ..write('ok')
        ..close();
      return;
    }

    request.response
      ..statusCode = HttpStatus.notFound
      ..write('not found')
      ..close();
  }
}
