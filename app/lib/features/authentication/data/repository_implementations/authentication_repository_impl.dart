import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/host_lookup_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
/*
  To-Do:
    - [ ] Standardize timeout exception handling (also in unit tests)
*/

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl({
    required this.authRemoteDataSource,
    required this.repositoryFailureHandler,
  });

  final AuthenticationRemoteDataSource authRemoteDataSource;
  final RepositoryFailureHandler repositoryFailureHandler;

  @override
  Future<Either<Failure, bool>> isServerSetUp() async {
    try {
      final isSetupComplete = await authRemoteDataSource.isServerSetUp();

      return Right(isSetupComplete);
    } catch (exception) {
      if (exception is ClientException) {
        final isTimeout = exception.message.contains("Operation timed out");

        if (isTimeout) {
          return Left(SendTimeoutFailure());
        }
      } else if (exception is PostgrestException) {
        return Left(ConnectionFailure());
      }
      rethrow;
    }
  }

  @override
  Future<Either<Failure, None>> isServerConnectionValid() async {
    try {
      await authRemoteDataSource.isServerConnectionValid();

      return const Right(None());
    } catch (exception) {
      if (exception is ClientException) {
        final isTimeout = exception.message.contains("Operation timed out");

        if (isTimeout) {
          return Left(SendTimeoutFailure());
        }

        final hasFailedHostLookup = exception.message.contains(
          "Failed host lookup",
        );

        if (hasFailedHostLookup) {
          return Left(HostLookupFailure());
        }
      } else if (exception is ArgumentError || exception is FormatException) {
        return Left(InvalidUrlFormatFailure());
      } else if (exception is PostgrestException) {
        return Left(ConnectionFailure());
      }
      rethrow;
    }
  }

  @override
  Future<Either<Failure, None>> initializeServerConnection({
    required String serverUrl,
  }) async {
    await authRemoteDataSource.initializeServerConnection(serverUrl: serverUrl);

    return Right(None());
  }

  @override
  Future<Either<Failure, None>> signUpInitialAdmin({
    required String username,
    required String email,
    required String password,
  }) {
    // TODO: implement signUpInitialAdmin
    throw UnimplementedError();
  }
}
