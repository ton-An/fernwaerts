import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/host_lookup_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
/*
  To-Do:
    - [ ] Standardize timeout exception handling (also in unit tests)
*/

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
    required this.repositoryFailureHandler,
  });

  final AuthenticationRemoteDataSource authRemoteDataSource;
  final AuthenticationLocalDataSource authLocalDataSource;
  final RepositoryFailureHandler repositoryFailureHandler;

  @override
  Future<Either<Failure, bool>> isServerSetUp() async {
    try {
      final isSetupComplete = await authRemoteDataSource.isServerSetUp();

      return Right(isSetupComplete);
    } catch (exception) {
      if (exception is ClientException) {
        final isTimeout = exception.message.contains('Operation timed out');

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
        final isTimeout = exception.message.contains('Operation timed out');

        if (isTimeout) {
          return Left(SendTimeoutFailure());
        }

        final hasFailedHostLookup = exception.message.contains(
          'Failed host lookup',
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
    required String serverUrl,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await authRemoteDataSource.signUpInitialAdmin(
        serverUrl: serverUrl,
        username: username,
        email: email,
        password: password,
      );

      return const Right(None());
    } on DioException catch (dioException) {
      final Failure failure = repositoryFailureHandler.dioExceptionMapper(
        dioException: dioException,
      );

      return Left(failure);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Stream<AuthenticationState> authenticationStateStream() {
    // TODO: implement authenticationStateStream
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getSavedServerUrl() {
    // TODO: implement getSavedServerUrl
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> hasServerConnectionSaved() async {
    try {
      final bool hasServerConnectionSaved =
          await authLocalDataSource.hasServerConnectionSaved();

      return Right(hasServerConnectionSaved);
    } on PlatformException {
      return Left(StorageReadFailure());
    }
  }

  @override
  bool isSignedIn() {
    return authRemoteDataSource.isSignedIn();
  }

  @override
  Future<Either<Failure, None>> signIn({
    required String username,
    required String password,
  }) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
