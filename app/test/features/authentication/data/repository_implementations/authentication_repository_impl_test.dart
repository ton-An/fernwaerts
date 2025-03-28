import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/features/authentication/data/repository_implementations/authentication_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late AuthenticationRepositoryImpl authenticationRepositoryImpl;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockRepositoryFailureHandler mockRepositoryFailureHandler;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockRepositoryFailureHandler = MockRepositoryFailureHandler();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl(
      authRemoteDataSource: mockAuthRemoteDataSource,
      repositoryFailureHandler: mockRepositoryFailureHandler,
    );
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
    registerFallbackValue(tBadResponseDioException);
  });

  group("isServerSetUp", () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.isServerSetUp(),
      ).thenAnswer((_) async => true);
    });

    test(
      "should check if the server is set up and return the result",
      () async {
        // act
        final result = await authenticationRepositoryImpl.isServerSetUp();

        // assert
        verify(() => mockAuthRemoteDataSource.isServerSetUp());
        expect(result, Right(true));
      },
    );

    test("should convert ClientExceptions to SendTimeoutFailure", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerSetUp(),
      ).thenThrow(tTimeoutClientException);

      // act
      final result = await authenticationRepositoryImpl.isServerSetUp();

      // assert
      expect(result, Left<Failure, bool>(SendTimeoutFailure()));
    });

    test("should convert PostgresException to ConnectionFailure", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerSetUp(),
      ).thenThrow(tPostgresException);

      // act
      final result = await authenticationRepositoryImpl.isServerSetUp();

      // assert
      expect(result, Left<Failure, bool>(ConnectionFailure()));
    });
  });

  group("isServerConnectionValid", () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(),
      ).thenAnswer((_) => Future.value());
    });

    test("should check if the server is reachable and return None", () async {
      // act
      final result =
          await authenticationRepositoryImpl.isServerConnectionValid();

      // assert
      verify(() => mockAuthRemoteDataSource.isServerConnectionValid());
      expect(result, Right<Failure, None>(None()));
    });

    test("should convert ClientExceptions to SendTimeoutFailure", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(),
      ).thenThrow(tTimeoutClientException);

      // act
      final result =
          await authenticationRepositoryImpl.isServerConnectionValid();

      // assert
      expect(result, Left<Failure, bool>(SendTimeoutFailure()));
    });

    test("should convert ArgumentError to InvalidUrlFormatFailure", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(),
      ).thenThrow(tArgumentError);

      // act
      final result =
          await authenticationRepositoryImpl.isServerConnectionValid();

      // assert
      expect(result, Left<Failure, bool>(InvalidUrlFormatFailure()));
    });

    test("should convert FormatException to InvalidUrlFormatFailure", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(),
      ).thenThrow(tFormatException);

      // act
      final result =
          await authenticationRepositoryImpl.isServerConnectionValid();

      // assert
      expect(result, Left<Failure, bool>(InvalidUrlFormatFailure()));
    });

    test("should convert PostgresException to ConnectionFailure", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(),
      ).thenThrow(tPostgresException);

      // act
      final result =
          await authenticationRepositoryImpl.isServerConnectionValid();

      // assert
      expect(result, Left<Failure, bool>(ConnectionFailure()));
    });
  });
}
