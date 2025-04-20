import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/authentication/invalid_credentials_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/likely_configuration_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
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
      return const Left(ConnectionFailure());
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
        return const Left(InvalidUrlFormatFailure());
      } else if (exception is PostgrestException) {
        return const Left(ConnectionFailure());
      } else if (exception.runtimeType.toString() == "_TypeError") {
        return const Left(LikelyConfigurationIssueFailure());
      }
      rethrow;
    }
  }

  @override
  Future<Either<Failure, None>> initializeServerConnection({
    required String serverUrl,
  }) async {
    await authRemoteDataSource.initializeServerConnection(serverUrl: serverUrl);

    return const Right(None());
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
      return const Left(StorageReadFailure());
    }
  }

  @override
  bool isSignedIn() {
    return authRemoteDataSource.isSignedIn();
  }

  @override
  Future<Either<Failure, None>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await authRemoteDataSource.signIn(email: email, password: password);

      return const Right(None());
    } on AuthException catch (authException) {
      final String? errorCode = authException.code;
      if (errorCode == 'invalid_credentials' ||
          errorCode == 'validation_failed') {
        return const Left(InvalidCredentialsFailure());
      }

      rethrow;
    } on ClientException catch (clientException, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: clientException,
        stackTrace: stackTrace,
      );

      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, None>> removeSavedServer() async {
    try {
      await authLocalDataSource.removeSavedServer();

      return const Right(None());
    } on PlatformException {
      return const Left(StorageWriteFailure());
    }
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  @override
  Future<Either<Failure, None>> saveServerUrl({
    required String serverUrl,
  }) async {
    try {
      await authLocalDataSource.saveServerUrl(serverUrl: serverUrl);

      return const Right(None());
    } on PlatformException {
      return const Left(StorageWriteFailure());
    }
  }
}
