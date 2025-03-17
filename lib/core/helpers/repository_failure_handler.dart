import 'package:dio/dio.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/bad_certificate_failure.dart';
import 'package:location_history/core/failures/networking/bad_response_failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/connection_timeout_failure.dart';
import 'package:location_history/core/failures/networking/receive_timeout_failure.dart';
import 'package:location_history/core/failures/networking/request_cancelled_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

/* 
  To-Dos:
  - [ ] Log exceptions
*/

/// {@template repository_failure_handler}
/// __Repository Failure Handler__ converts exceptions occurring in the repository layer to [Failure]s
/// {@endtemplate}
class RepositoryFailureHandler {
  /// {@macro repository_failure_handler}
  const RepositoryFailureHandler();

  /// Maps [DioException]s to [Failure]s
  ///
  /// Parameters:
  /// - [DioException]: exception
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
  Failure dioExceptionMapper(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return const ConnectionTimeoutFailure();
      case DioExceptionType.sendTimeout:
        return const SendTimeoutFailure();
      case DioExceptionType.receiveTimeout:
        return const ReceiveTimeoutFailure();
      case DioExceptionType.badCertificate:
        return const BadCertificateFailure();
      case DioExceptionType.badResponse:
        return const BadResponseFailure();
      case DioExceptionType.cancel:
        return const RequestCancelledFailure();
      case DioExceptionType.connectionError:
        return const ConnectionFailure();
      case DioExceptionType.unknown:
        return const UnknownRequestFailure();
    }
  }
}
