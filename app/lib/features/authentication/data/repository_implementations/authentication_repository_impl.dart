import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
/*
  To-Do:
    - [ ] Standardize timeout exception handling (also in unit tests)
    - [ ] Standardize error handling of supabase errors
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
    } on ClientException catch (exception, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: exception,
        stackTrace: stackTrace,
      );

      return Left(failure);
    } on PostgrestException {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, None>> isServerConnectionValid() async {
    try {
      await authRemoteDataSource.isServerConnectionValid();

      return const Right(None());
    } catch (exception, stackTrace) {
      if (exception is ClientException) {
        final Failure failure = repositoryFailureHandler
            .clientExceptionConverter(
              clientException: exception,
              stackTrace: stackTrace,
            );

        return Left(failure);
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
    return authRemoteDataSource.authenticationStateStream();
  }

  @override
  Future<Either<Failure, String?>> getSavedServerUrl() async {
    try {
      final String? savedServerUrl =
          await authLocalDataSource.getSavedServerUrl();

      return Right(savedServerUrl);
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
  }) async {
    try {
      await authRemoteDataSource.signIn(username: username, password: password);

      return const Right(None());
    } on ClientException catch (clientException, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: clientException,
        stackTrace: stackTrace,
      );

      return Left(failure);
    }
  }
}
