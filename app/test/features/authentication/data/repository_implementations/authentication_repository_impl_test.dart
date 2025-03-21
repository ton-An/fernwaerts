import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/bad_response_failure.dart';
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
        () => mockAuthRemoteDataSource.isServerSetUp(
          serverUrl: any(named: "serverUrl"),
        ),
      ).thenAnswer((_) async => true);
    });

    test(
      "should check if the server is set up and return the result",
      () async {
        // act
        final result = await authenticationRepositoryImpl.isServerSetUp(
          serverUrl: tServerUrl,
        );

        // assert
        verify(
          () => mockAuthRemoteDataSource.isServerSetUp(serverUrl: tServerUrl),
        );
        expect(result, Right(true));
      },
    );

    test("should convert DioExceptions to Failures", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerSetUp(
          serverUrl: any(named: "serverUrl"),
        ),
      ).thenThrow(tBadResponseDioException);
      when(
        () => mockRepositoryFailureHandler.dioExceptionMapper(
          dioException: any(named: "dioException"),
        ),
      ).thenReturn(BadResponseFailure());

      // act
      final result = await authenticationRepositoryImpl.isServerSetUp(
        serverUrl: tServerUrl,
      );

      // assert
      expect(result, Left<Failure, bool>(BadResponseFailure()));
    });

    test("should relay Failures", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerSetUp(
          serverUrl: any(named: "serverUrl"),
        ),
      ).thenThrow(tUnknownRequestFailure);

      // act
      final result = await authenticationRepositoryImpl.isServerSetUp(
        serverUrl: tServerUrl,
      );

      // assert
      expect(result, Left<Failure, bool>(tUnknownRequestFailure));
    });
  });

  group("isServerReachable", () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.isServerReachable(
          serverUrl: any(named: "serverUrl"),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test("should check if the server is reachable and return None", () async {
      // act
      final result = await authenticationRepositoryImpl.isServerReachable(
        serverUrl: tServerUrl,
      );

      // assert
      verify(
        () => mockAuthRemoteDataSource.isServerReachable(serverUrl: tServerUrl),
      );
      expect(result, Right<Failure, None>(None()));
    });

    test("should convert DioExceptions to Failures", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerReachable(
          serverUrl: any(named: "serverUrl"),
        ),
      ).thenThrow(tBadResponseDioException);
      when(
        () => mockRepositoryFailureHandler.dioExceptionMapper(
          dioException: any(named: "dioException"),
        ),
      ).thenReturn(BadResponseFailure());

      // act
      final result = await authenticationRepositoryImpl.isServerReachable(
        serverUrl: tServerUrl,
      );

      // assert
      expect(result, Left<Failure, bool>(BadResponseFailure()));
    });

    test("should relay Failures", () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerReachable(
          serverUrl: any(named: "serverUrl"),
        ),
      ).thenThrow(tUnknownRequestFailure);

      // act
      final result = await authenticationRepositoryImpl.isServerReachable(
        serverUrl: tServerUrl,
      );

      // assert
      expect(result, Left<Failure, bool>(tUnknownRequestFailure));
    });
  });
}
