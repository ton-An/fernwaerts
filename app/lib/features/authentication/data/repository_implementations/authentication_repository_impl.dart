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
    - [ ] Implement checkIfServerSetUp method
*/

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl({
    required this.authRemoteDataSource,
    required this.repositoryFailureHandler,
  });

  final AuthenticationRemoteDataSource authRemoteDataSource;
  final RepositoryFailureHandler repositoryFailureHandler;

  @override
  Future<Either<Failure, bool>> checkIfServerSetUp({required Uri serverUrl}) {
    // TODO: implement checkIfServerSetUp
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> checkServerReachability({
    required Uri serverUrl,
  }) async {
    try {
      await authRemoteDataSource.checkServerReachability(serverUrl);

      return const Right(None());
    } on DioException catch (dioException) {
      final Failure failure = repositoryFailureHandler.dioExceptionMapper(
        dioException,
      );

      return Left(failure);
    }
  }
}
