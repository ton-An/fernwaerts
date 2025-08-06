import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/authentication/invalid_credentials_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
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
  Future<Either<Failure, None>> isServerConnectionValid({
    required String serverUrl,
  }) async {
    try {
      await authRemoteDataSource.isServerConnectionValid(serverUrl: serverUrl);

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
  Future<Either<Failure, None>> initializeServerConnection({
    required SupabaseInfo supabaseInfo,
  }) async {
    await authRemoteDataSource.initializeServerConnection(
      supabaseInfo: supabaseInfo,
    );

    return const Right(None());
  }

  @override
  Future<Either<Failure, None>> initializeSyncServerConnection({
    required PowersyncInfo powersyncInfo,
  }) async {
    await authRemoteDataSource.initializeSyncServerConnection(
      powersyncInfo: powersyncInfo,
    );

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
  Future<Either<Failure, ServerInfo>> getSavedServerInfo() async {
    try {
      final ServerInfo savedServerInfo =
          await authLocalDataSource.getSavedServerInfo();

      return Right(savedServerInfo);
    } on PlatformException {
      return const Left(StorageReadFailure());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<bool> isSignedIn() {
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
  Future<Either<Failure, None>> saveServerInfo({
    required ServerInfo serverInfo,
  }) async {
    try {
      await authLocalDataSource.saveServerInfo(serverInfo: serverInfo);

      return const Right(None());
    } on PlatformException {
      return const Left(StorageWriteFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getAnonKeyFromServer({
    required String serverUrl,
  }) async {
    try {
      final String anonKey = await authRemoteDataSource.getAnonKeyFromServer(
        serverUrl: serverUrl,
      );

      return Right(anonKey);
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
  Future<Either<Failure, String>> getCurrentUserId() async {
    try {
      final String userId = await authRemoteDataSource.getCurrentUserId();

      return Right(userId);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<void> deleteLocalDBCache() async {
    return authLocalDataSource.deleteLocalDBCache();
  }

  @override
  Future<Either<Failure, None>> deleteLocalStorage() async {
    try {
      await authLocalDataSource.deleteLocalStorage();

      return const Right(None());
    } on PlatformException {
      return const Left(StorageWriteFailure());
    }
  }

  @override
  Future<Either<Failure, PowersyncInfo>> getSyncServerInfo() async {
    return const Right(PowersyncInfo(url: 'http://192.168.0.83:7901'));
  }
}
