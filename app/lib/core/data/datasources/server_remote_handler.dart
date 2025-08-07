import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
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
  /// - [ServerType]: type of the server the request is being sent to (important for error logging)
  ///
  /// Throws:
  /// {@template server_remote_handler_exceptions}
  /// - [StatusCodeNotOkFailure]
  /// - [UnknownRequestFailure]
  /// - [DioException]
  /// {@endtemplate}
  Future<Map<String, dynamic>?> get({
    required Uri url,
    required ServerType serverType,
  });

  /// Sends a POST request to the server
  ///
  /// Parameters:
  /// - [String]: path on server
  /// - [Map]: request body
  /// - [ServerType]: type of the server the request is being sent to (important for error logging)
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<Map<String, dynamic>?> post({
    required Uri url,
    required Map<String, dynamic> body,
    required ServerType serverType,
  });
}

class ServerRemoteHandlerImpl extends ServerRemoteHandler {
  const ServerRemoteHandlerImpl({required this.dio});

  final Dio dio;

  @override
  Future<Map<String, dynamic>?> get({
    required Uri url,
    required ServerType serverType,
  }) async {
    return _dioCallHandler(
      dioFunction: () => dio.getUri(url),
      serverType: serverType,
    );
  }

  @override
  Future<Map<String, dynamic>?> post({
    required Uri url,
    required Map<String, dynamic> body,
    required ServerType serverType,
  }) async {
    return _dioCallHandler(
      dioFunction: () => dio.postUri(url, data: body),
      serverType: serverType,
    );
  }

  Future<Map<String, dynamic>?> _dioCallHandler({
    required DioFunction dioFunction,
    required ServerType serverType,
  }) async {
    final Response response = await dioFunction();

    if (response.statusCode == HttpStatus.ok) {
      if (response.data is String) {
        return null;
      }

      return response.data;
    } else if (response.statusCode != null &&
        response.statusCode != HttpStatus.ok) {
      throw StatusCodeNotOkFailure(
        statusCode: response.statusCode!,
        serverType: serverType,
      );
    }
    throw UnknownRequestFailure(serverType: serverType);
  }
}
