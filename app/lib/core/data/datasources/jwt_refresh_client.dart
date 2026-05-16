import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template jwt_refresh_client}
/// HTTP client that attaches the current Supabase access token to each request.
///
/// Requests are sent without an `Authorization` header when there is no active
/// Supabase session. The client does not refresh sessions itself; Supabase owns
/// token refresh lifecycle.
/// {@endtemplate}
class JWTRefreshClient extends http.BaseClient {
  /// {@macro jwt_refresh_client}
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
