import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

/// A Dio request callback executed by [ServerRemoteHandlerImpl].
typedef DioFunction = Future<Response> Function();

/// {@template server_remote_handler}
/// Shared HTTP helper for requests to configured Fernwaerts server endpoints.
///
/// The handler returns decoded JSON object responses and normalizes non-200
/// responses into app failures that repositories can map or return.
/// {@endtemplate}
abstract class ServerRemoteHandler {
  /// {@macro server_remote_handler}
  const ServerRemoteHandler();

  /// Sends a GET request to [url].
  ///
  /// Parameters:
  /// - url: [Uri] absolute endpoint URL.
  /// - serverType: [ServerType] server category used in network failures.
  ///
  /// Returns:
  /// - [Map<String, dynamic>?] decoded response body, or `null` when the
  ///   response body is a plain string.
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

  /// Sends a POST request to [url].
  ///
  /// Parameters:
  /// - url: [Uri] absolute endpoint URL.
  /// - body: [Map<String, dynamic>] JSON body sent with the request.
  /// - serverType: [ServerType] server category used in network failures.
  ///
  /// Returns:
  /// - [Map<String, dynamic>?] decoded response body, or `null` when the
  ///   response body is a plain string.
  ///
  /// Throws:
  /// {@macro server_remote_handler_exceptions}
  Future<Map<String, dynamic>?> post({
    required Uri url,
    required Map<String, dynamic> body,
    required ServerType serverType,
  });
}

/// {@macro server_remote_handler}
class ServerRemoteHandlerImpl extends ServerRemoteHandler {
  /// {@macro server_remote_handler}
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
