import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/misc/url_path_constants.dart';

/*
  To-Do:
    - [ ] Write unit tests
    - [ ] Standardize error handling and server calls
*/

abstract class AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSource();

  Future<void> isServerReachable(Uri serverUrl);

  Future<bool> isServerSetUp(Uri serverUrl);
}

class AuthRemoteDataSourceImpl extends AuthenticationRemoteDataSource {
  const AuthRemoteDataSourceImpl({required this.serverRemoteHandler});

  final ServerRemoteHandler serverRemoteHandler;

  @override
  Future<bool> isServerSetUp(Uri serverUrl) async {
    final Uri fullUrl = serverUrl.replace(
      path: UrlPathConstants.isServerSetUpPath,
    );

    final Map<String, dynamic>? responseData = await serverRemoteHandler.get(
      url: fullUrl,
    );

    return responseData?["data"]?["is_server_set_up"]!;
  }

  @override
  Future<void> isServerReachable(Uri serverUrl) async {
    final Uri fullUrl = serverUrl.replace(
      path: UrlPathConstants.healthCheckPath,
    );

    await serverRemoteHandler.get(url: fullUrl);
  }
}
