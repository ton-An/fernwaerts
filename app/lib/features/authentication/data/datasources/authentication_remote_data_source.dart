import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

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
  const AuthRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<bool> isServerSetUp(Uri serverUrl) async {
    const String isServerSetUpPath = "/functions/v1/is_set_up_complete";
    final Uri fullUrl = serverUrl.replace(path: isServerSetUpPath);

    final Response response = await dio.getUri(fullUrl);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> responseData = response.data;

      final bool isSetupComplete = responseData["data"]['is_set_up_complete'];

      return isSetupComplete;
    } else if (response.statusCode != null &&
        response.statusCode != HttpStatus.ok) {
      throw StatusCodeNotOkFailure(statusCode: response.statusCode!);
    }
    throw UnknownRequestFailure();
  }

  @override
  Future<void> isServerReachable(Uri serverUrl) async {
    const String healthCheckPath = "/auth/v1/health";
    final Uri fullUrl = serverUrl.replace(path: healthCheckPath);

    final Response response = await dio.getUri(fullUrl);

    if (response.statusCode != null && response.statusCode != HttpStatus.ok) {
      throw StatusCodeNotOkFailure(statusCode: response.statusCode!);
    } else if (response.statusCode == null) {
      throw UnknownRequestFailure();
    }
  }
}
