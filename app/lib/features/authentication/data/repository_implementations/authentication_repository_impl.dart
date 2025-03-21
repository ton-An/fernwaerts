import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/helpers/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Complete the Failure conversion
    - [ ] Write unit tests
*/

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl({
    required this.authRemoteDataSource,
    required this.repositoryFailureHandler,
  });

  final AuthenticationRemoteDataSource authRemoteDataSource;
  final RepositoryFailureHandler repositoryFailureHandler;

  @override
  Future<Either<Failure, bool>> isServerSetUp({required Uri serverUrl}) async {
    try {
      final isSetupComplete = await authRemoteDataSource.isServerSetUp(
        serverUrl,
      );

      return Right(isSetupComplete);
    } on DioException catch (dioException) {
      final Failure failure = repositoryFailureHandler.dioExceptionMapper(
        dioException,
      );

      return Left(failure);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, None>> isServerReachable({
    required Uri serverUrl,
  }) async {
    try {
      await authRemoteDataSource.isServerReachable(serverUrl);

      return const Right(None());
    } on DioException catch (dioException) {
      final Failure failure = repositoryFailureHandler.dioExceptionMapper(
        dioException,
      );

      return Left(failure);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
