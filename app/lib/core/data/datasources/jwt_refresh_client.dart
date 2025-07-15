import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template jwtrefresh_client}
/// A class that represents jwtrefresh client.
/// {@endtemplate}
class JWTRefreshClient extends http.BaseClient {
/// {@macro jwtrefresh_client}
  JWTRefreshClient() : _innerClient = http.Client();

  final http.Client _innerClient;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;

    if (accessToken != null) {
      request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }

    return _innerClient.send(request);
  }

  @override
  void close() {
    _innerClient.close();
    super.close();
  }
}
