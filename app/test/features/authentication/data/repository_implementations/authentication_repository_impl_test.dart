import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/bad_response_failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/data/repository_implementations/authentication_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late AuthenticationRepositoryImpl authenticationRepositoryImpl;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockRepositoryFailureHandler mockRepositoryFailureHandler;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockRepositoryFailureHandler = MockRepositoryFailureHandler();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl(
      authRemoteDataSource: mockAuthRemoteDataSource,
      authLocalDataSource: mockAuthLocalDataSource,
      repositoryFailureHandler: mockRepositoryFailureHandler,
    );
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
    registerFallbackValue(tBadResponseDioException);
    registerFallbackValue(tTimeoutClientException);
    registerFallbackValue(tStackTrace);
  });

  group('isServerSetUp()', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.isServerSetUp(),
      ).thenAnswer((_) async => true);
    });

    test(
      'should check if the server is set up and return the result',
      () async {
        // act
        final result = await authenticationRepositoryImpl.isServerSetUp();

        // assert
        verify(() => mockAuthRemoteDataSource.isServerSetUp());
        expect(result, Right(true));
      },
    );

    test(
      'should convert ClientExceptions to Failures and return them',
      () async {
        // arrange
        when(
          () => mockAuthRemoteDataSource.isServerSetUp(),
        ).thenThrow(tTimeoutClientException);
        when(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: any(named: 'clientException'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenReturn(SendTimeoutFailure());

        // act
        final result = await authenticationRepositoryImpl.isServerSetUp();

        // assert
        verify(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: tTimeoutClientException,
            stackTrace: any(named: 'stackTrace'),
          ),
        );
        expect(result, Left(SendTimeoutFailure()));
      },
    );

    test('should convert PostgresException to ConnectionFailure', () async {
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

  group('isServerConnectionValid()', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(),
      ).thenAnswer((_) => Future.value());
    });

    test('should check if the server is reachable and return None', () async {
      // act
      final result =
          await authenticationRepositoryImpl.isServerConnectionValid();

      // assert
      verify(() => mockAuthRemoteDataSource.isServerConnectionValid());
      expect(result, Right<Failure, None>(None()));
    });

    test(
      'should convert ClientExceptions to Failures and return them',
      () async {
        // arrange
        when(
          () => mockAuthRemoteDataSource.isServerConnectionValid(),
        ).thenThrow(tTimeoutClientException);
        when(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: any(named: 'clientException'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenReturn(SendTimeoutFailure());

        // act
        final result =
            await authenticationRepositoryImpl.isServerConnectionValid();

        // assert
        verify(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: tTimeoutClientException,
            stackTrace: any(named: 'stackTrace'),
          ),
        );
        expect(result, Left(SendTimeoutFailure()));
      },
    );

    test('should convert ArgumentError to InvalidUrlFormatFailure', () async {
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

    test('should convert FormatException to InvalidUrlFormatFailure', () async {
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

    test('should convert PostgresException to ConnectionFailure', () async {
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

  group('signUpInitialAdmin()', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.signUpInitialAdmin(
          serverUrl: tServerUrlString,

          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should check if the server is reachable and return None', () async {
      // act
      final result = await authenticationRepositoryImpl.signUpInitialAdmin(
        serverUrl: tServerUrlString,

        username: tUsername,
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(
        () => mockAuthRemoteDataSource.signUpInitialAdmin(
          serverUrl: tServerUrlString,
          username: tUsername,
          email: tEmail,
          password: tPassword,
        ),
      );
      expect(result, Right<Failure, None>(None()));
    });

    test('should convert DioExceptions to Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.signUpInitialAdmin(
          serverUrl: any(named: 'serverUrl'),
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tBadResponseDioException);
      when(
        () => mockRepositoryFailureHandler.dioExceptionMapper(
          dioException: any(named: 'dioException'),
        ),
      ).thenReturn(BadResponseFailure());

      // act
      final result = await authenticationRepositoryImpl.signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, Left<Failure, bool>(BadResponseFailure()));
    });

    test('should relay Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.signUpInitialAdmin(
          serverUrl: any(named: 'serverUrl'),
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tUnknownRequestFailure);

      // act
      final result = await authenticationRepositoryImpl.signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, Left<Failure, bool>(tUnknownRequestFailure));
    });
  });

  group('getSavedServerUrl()', () {
    setUp(() {
      when(
        () => mockAuthLocalDataSource.getSavedServerUrl(),
      ).thenAnswer((_) async => tServerUrlString);
    });

    test('should get the saved server url and return it', () async {
      // act
      final result = await authenticationRepositoryImpl.getSavedServerUrl();

      // assert
      expect(result, Right(tServerUrlString));
    });

    test(
      'should return a StorageReadFailure if a PlatformException is thrown',
      () async {
        when(
          () => mockAuthLocalDataSource.getSavedServerUrl(),
        ).thenThrow(tPlatformException);

        // act
        final result = await authenticationRepositoryImpl.getSavedServerUrl();

        // assert
        expect(result, Left(StorageReadFailure()));
      },
    );
  });

  group('signIn()', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should sign in the user and return None', () async {
      // act
      final result = await authenticationRepositoryImpl.signIn(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(
        () =>
            mockAuthRemoteDataSource.signIn(email: tEmail, password: tPassword),
      );
      expect(result, const Right(None()));
    });

    test(
      'should convert ClientExceptions to Failures and return them',
      () async {
        // arrange
        when(
          () => mockAuthRemoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tTimeoutClientException);
        when(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: any(named: 'clientException'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).thenReturn(SendTimeoutFailure());

        // act
        final result = await authenticationRepositoryImpl.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        verify(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: tTimeoutClientException,
            stackTrace: any(named: 'stackTrace'),
          ),
        );
        expect(result, Left(SendTimeoutFailure()));
      },
    );
  });

  group('removeSavedServer()', () {
    setUp(() {
      when(
        () => mockAuthLocalDataSource.removeSavedServer(),
      ).thenAnswer((_) => Future.value());
    });

    test('should remove the saved server and return None', () async {
      // act
      final result = await authenticationRepositoryImpl.removeSavedServer();

      // assert
      verify(() => mockAuthLocalDataSource.removeSavedServer());
      expect(result, Right(None()));
    });

    test(
      'should convert PlatformException to StorageWriteFailure and return it',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.removeSavedServer(),
        ).thenThrow(tPlatformException);

        // act
        final result = await authenticationRepositoryImpl.removeSavedServer();

        // assert
        expect(result, Left(StorageWriteFailure()));
      },
    );
  });
}
