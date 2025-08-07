import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/bad_certificate_failure.dart';
import 'package:location_history/core/failures/networking/bad_response_failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/connection_timeout_failure.dart';
import 'package:location_history/core/failures/networking/host_lookup_failure.dart';
import 'package:location_history/core/failures/networking/receive_timeout_failure.dart';
import 'package:location_history/core/failures/networking/request_cancelled_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/* 
  To-Dos:
  - [ ] Log exceptions
*/

/// {@template repository_failure_handler}
/// __Repository Failure Handler__ converts exceptions occurring in the repository layer to [Failure]s
/// {@endtemplate}
abstract class RepositoryFailureHandler {
  /// {@macro repository_failure_handler}
  const RepositoryFailureHandler();

  /// Maps [DioException]s to [Failure]s
  ///
  /// Parameters:
  /// - [DioException]: exception
  /// - [ServerType]: type of the server the request was sent to
  ///
  /// Returns:
  /// {@template converted_dio_exceptions}
  /// - [ConnectionTimeoutFailure]
  /// - [SendTimeoutFailure]
  /// - [ReceiveTimeoutFailure]
  /// - [BadCertificateFailure]
  /// - [BadResponseFailure]
  /// - [RequestCancelledFailure]
  /// - [ConnectionFailure]
  /// - [UnknownRequestFailure]
  /// {@endtemplate}
  Failure dioExceptionMapper({
    required DioException dioException,
    required ServerType serverType,
  });

  /// Converts [ClientException]s to [Failure]s
  ///
  /// If the exception is not handled, it will be rethrown with the original stack trace.
  ///
  /// Parameters:
  /// - [ClientException]: exception
  /// - [StackTrace]: stack trace
  /// - [ServerType]: type of the server the request was sent to
  ///
  /// Returns:
  /// {@template converted_client_exceptions}
  /// - [HostLookupFailure]
  /// - [ConnectionFailure]
  /// - [SendTimeoutFailure]
  /// {@endtemplate}
  Failure clientExceptionConverter({
    required ClientException clientException,
    required StackTrace stackTrace,
    required ServerType serverType,
  });

  /// Converts [FunctionException]s to [Failure]s
  ///
  /// If the exception is not handled, it will be rethrown with the original stack trace.
  ///
  /// Parameters:
  /// - [FunctionException]: exception
  /// - [StackTrace]: stack trace
  /// - [ServerType]: type of the server the request was sent to
  ///
  /// Returns:
  /// {@template converted_supabase_functions_exception}
  /// - [StatusCodeNotOkFailure]
  /// {@endtemplate}
  Failure supabaseFunctionExceptionConverter({
    required FunctionException functionException,
  });
}

/// {@macro repository_failure_handler}
class RepositoryFailureHandlerImpl extends RepositoryFailureHandler {
  /// {@macro repository_failure_handler}
  const RepositoryFailureHandlerImpl();

  @override
  Failure dioExceptionMapper({
    required DioException dioException,
    required ServerType serverType,
  }) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutFailure(serverType: serverType);
      case DioExceptionType.sendTimeout:
        return SendTimeoutFailure(serverType: serverType);
      case DioExceptionType.receiveTimeout:
        return ReceiveTimeoutFailure(serverType: serverType);
      case DioExceptionType.badCertificate:
        return BadCertificateFailure(serverType: serverType);
      case DioExceptionType.badResponse:
        return BadResponseFailure(serverType: serverType);
      case DioExceptionType.cancel:
        return RequestCancelledFailure(serverType: serverType);
      case DioExceptionType.connectionError:
        return ConnectionFailure(serverType: serverType);
      case DioExceptionType.unknown:
        return UnknownRequestFailure(serverType: serverType);
    }
  }

  @override
  Failure clientExceptionConverter({
    required ClientException clientException,
    required StackTrace stackTrace,
    required ServerType serverType,
  }) {
    //Host is down missing
    final isTimeout = clientException.message.contains('Operation timed out');

    if (isTimeout) {
      return SendTimeoutFailure(serverType: serverType);
    }

    final bool hasFailedHostLookup = clientException.message.contains(
      'Failed host lookup',
    );

    if (hasFailedHostLookup) {
      return HostLookupFailure(serverType: serverType);
    }

    final bool isHostDown = clientException.message.contains('Host is down');

    if (isHostDown) {
      return ConnectionFailure(serverType: serverType);
    }

    Error.throwWithStackTrace(clientException, stackTrace);
  }

  @override
  Failure supabaseFunctionExceptionConverter({
    required FunctionException functionException,
  }) {
    return StatusCodeNotOkFailure(
      serverType: ServerType.supabase,
      statusCode: functionException.status,
    );
  }
}
