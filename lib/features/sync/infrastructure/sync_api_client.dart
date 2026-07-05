import 'dart:convert';
import 'dart:io';

class SyncApiClient {
  const SyncApiClient();

  Future<bool> healthCheck(Uri baseUri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(baseUri.replace(path: '/health'));
      final response = await request.close();
      final body = await utf8.decodeStream(response);
      return response.statusCode == HttpStatus.ok && body == 'ok';
    } finally {
      client.close();
    }
  }
}
