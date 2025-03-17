import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';

/*
  To-Do:
    - [ ] Write unit tests
    - [ ] Implement checkIfServerSetUp method
*/

abstract class AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSource();

  Future<void> checkServerReachability(Uri serverUrl);

  Future<bool> checkIfServerSetUp(Uri serverUrl);
}

class AuthRemoteDataSourceImpl extends AuthenticationRemoteDataSource {
  const AuthRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<bool> checkIfServerSetUp(Uri serverUrl) {
    // TODO: implement checkIfServerSetUp
    throw UnimplementedError();
  }

  @override
  Future<void> checkServerReachability(Uri serverUrl) async {
    const String healthCheckPath = "/auth/v1/health";
    final Uri fullUrl = serverUrl.replace(path: healthCheckPath);

    final Response response = await dio.getUri(fullUrl);

    if (response.statusCode != null && response.statusCode != HttpStatus.ok) {
      throw StatusCodeNotOkFailure(statusCode: response.statusCode!);
    }
  }
}
