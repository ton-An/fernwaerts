import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

typedef DioFunction = Future<Response> Function();

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

  /// Sends a POST request to the server
  ///
  /// Parameters:
  /// - [String]: path on server
  /// - [Map]: request body
  ///
  /// Throws:
  Future<Map<String, dynamic>?> post({
    required Uri url,
    required Map<String, dynamic> body,
  });
}

class ServerRemoteHandlerImpl extends ServerRemoteHandler {
  const ServerRemoteHandlerImpl({required this.dio});

  final Dio dio;

  @override
  Future<Map<String, dynamic>?> get({required Uri url}) async {
    return _dioCallHandler(dioFunction: () => dio.getUri(url));
  }

  @override
  Future<Map<String, dynamic>?> post({
    required Uri url,
    required Map<String, dynamic> body,
  }) async {
    return _dioCallHandler(dioFunction: () => dio.postUri(url, data: body));
  }

  Future<Map<String, dynamic>?> _dioCallHandler({
    required DioFunction dioFunction,
  }) async {
    final Response response = await dioFunction();

    if (response.statusCode == HttpStatus.ok) {
      if (response.data is String) {
        return null;
      }

      return response.data;
    } else if (response.statusCode != null &&
        response.statusCode != HttpStatus.ok) {
      throw StatusCodeNotOkFailure(statusCode: response.statusCode!);
    }
    throw const UnknownRequestFailure();
  }
}
