import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

abstract class ServerRemoteHandler {
  const ServerRemoteHandler();

  /// Sends a GET request to the server
  ///
  /// Parameters:
  /// - [String]: path on the server
  ///
  /// Returns:
  /// - [Map]?: response body (if any)
  ///
  /// Throws:
  /// - [StatusCodeNotOkFailure]
  /// - [UnknownRequestFailure]
  /// - [DioException]
  Future<Map<String, dynamic>?> get({required Uri url});
}

class ServerRemoteHandlerImpl extends ServerRemoteHandler {
  const ServerRemoteHandlerImpl({required this.dio});

  final Dio dio;

  @override
  Future<Map<String, dynamic>?> get({required Uri url}) async {
    final Response response = await dio.getUri(url);

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else if (response.statusCode != null &&
        response.statusCode != HttpStatus.ok) {
      throw StatusCodeNotOkFailure(statusCode: response.statusCode!);
    }
    throw UnknownRequestFailure();
  }
}
