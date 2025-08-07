import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/bad_response_failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/data/repository_implementations/authentication_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

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
    registerFallbackValue(tServerInfo);
    registerFallbackValue(tBadResponseDioException);
    registerFallbackValue(tTimeoutClientException);
    registerFallbackValue(tStackTrace);
    registerFallbackValue(ServerType.supabase);
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
        expect(result, const Right(true));
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
            serverType: any(named: 'serverType'),
          ),
        ).thenReturn(SendTimeoutFailure(serverType: ServerType.supabase));

        // act
        final result = await authenticationRepositoryImpl.isServerSetUp();

        // assert
        verify(
          () => mockRepositoryFailureHandler.clientExceptionConverter(
            clientException: tTimeoutClientException,
            stackTrace: any(named: 'stackTrace'),
            serverType: any(named: 'serverType'),
          ),
        );
        expect(
          result,
          Left(SendTimeoutFailure(serverType: ServerType.supabase)),
        );
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
      expect(
        result,
        Left<Failure, bool>(ConnectionFailure(serverType: ServerType.supabase)),
      );
    });
  });

  group('isServerConnectionValid()', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should check if the server is reachable and return None', () async {
      // act
      final result = await authenticationRepositoryImpl.isServerConnectionValid(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(
        () => mockAuthRemoteDataSource.isServerConnectionValid(
          serverUrl: any(named: 'serverUrl'),
        ),
      );
      expect(result, const Right<Failure, None>(None()));
    });

    test('should convert DioExceptions to Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenThrow(tBadResponseDioException);
      when(
        () => mockRepositoryFailureHandler.dioExceptionMapper(
          dioException: any(named: 'dioException'),
          serverType: any(named: 'serverType'),
        ),
      ).thenReturn(BadResponseFailure(serverType: ServerType.supabase));

      // act
      final result = await authenticationRepositoryImpl.isServerConnectionValid(
        serverUrl: tServerUrlString,
      );

      // assert
      expect(
        result,
        Left<Failure, bool>(
          BadResponseFailure(serverType: ServerType.supabase),
        ),
      );
    });

    test('should relay Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.isServerConnectionValid(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenThrow(tUnknownRequestFailure);

      // act
      final result = await authenticationRepositoryImpl.isServerConnectionValid(
        serverUrl: tServerUrlString,
      );

      // assert
      expect(result, Left<Failure, bool>(tUnknownRequestFailure));
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
      expect(result, const Right<Failure, None>(None()));
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
          serverType: any(named: 'serverType'),
        ),
      ).thenReturn(BadResponseFailure(serverType: ServerType.supabase));

      // act
      final result = await authenticationRepositoryImpl.signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(
        result,
        Left<Failure, bool>(
          BadResponseFailure(serverType: ServerType.supabase),
        ),
      );
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

  group('getSavedServerInfo()', () {
    setUp(() {
      when(
        () => mockAuthLocalDataSource.getSavedServerInfo(),
      ).thenAnswer((_) async => tServerInfo);
    });

    test('should get the saved server info and return it', () async {
      // act
      final result = await authenticationRepositoryImpl.getSavedServerInfo();

      // assert
      expect(result, const Right(tServerInfo));
    });

    test(
      'should return a StorageReadFailure if a PlatformException is thrown',
      () async {
        when(
          () => mockAuthLocalDataSource.getSavedServerInfo(),
        ).thenThrow(tPlatformException);

        // act
        final result = await authenticationRepositoryImpl.getSavedServerInfo();

        // assert
        expect(result, const Left(StorageReadFailure()));
      },
    );

    test('should relay Failures', () async {
      // arrange
      when(
        () => mockAuthLocalDataSource.getSavedServerInfo(),
      ).thenThrow(const NoSavedServerFailure());

      // act
      final result = await authenticationRepositoryImpl.getSavedServerInfo();

      // assert
      expect(result, const Left<Failure, bool>(NoSavedServerFailure()));
    });
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
            serverType: any(named: 'serverType'),
          ),
        ).thenReturn(SendTimeoutFailure(serverType: ServerType.supabase));

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
            serverType: any(named: 'serverType'),
          ),
        );
        expect(
          result,
          Left(SendTimeoutFailure(serverType: ServerType.supabase)),
        );
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
      expect(result, const Right(None()));
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
        expect(result, const Left(StorageWriteFailure()));
      },
    );
  });

  group('saveServerInfo()', () {
    setUp(() {
      when(
        () => mockAuthLocalDataSource.saveServerInfo(
          serverInfo: any(named: 'serverInfo'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should save the server info and return None', () async {
      // act
      final result = await authenticationRepositoryImpl.saveServerInfo(
        serverInfo: tServerInfo,
      );

      // assert
      verify(
        () => mockAuthLocalDataSource.saveServerInfo(serverInfo: tServerInfo),
      );
      expect(result, const Right(None()));
    });

    test(
      'should convert PlatformException to StorageWriteFailure and return it',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.saveServerInfo(
            serverInfo: any(named: 'serverInfo'),
          ),
        ).thenThrow(tPlatformException);

        // act
        final result = await authenticationRepositoryImpl.saveServerInfo(
          serverInfo: tServerInfo,
        );

        // assert
        expect(result, const Left(StorageWriteFailure()));
      },
    );
  });

  group('isServerConnectionValid()', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.getAnonKeyFromServer(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenAnswer((_) async => tAnonKey);
    });

    test('should get the anon key from the server and return it', () async {
      // act
      final result = await authenticationRepositoryImpl.getAnonKeyFromServer(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(
        () => mockAuthRemoteDataSource.getAnonKeyFromServer(
          serverUrl: tServerUrlString,
        ),
      );
      expect(result, const Right<Failure, String>(tAnonKey));
    });

    test('should convert DioExceptions to Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.getAnonKeyFromServer(
          serverUrl: tServerUrlString,
        ),
      ).thenThrow(tBadResponseDioException);
      when(
        () => mockRepositoryFailureHandler.dioExceptionMapper(
          dioException: any(named: 'dioException'),
          serverType: any(named: 'serverType'),
        ),
      ).thenReturn(BadResponseFailure(serverType: ServerType.supabase));

      // act
      final result = await authenticationRepositoryImpl.getAnonKeyFromServer(
        serverUrl: tServerUrlString,
      );

      // assert
      expect(
        result,
        Left<Failure, bool>(
          BadResponseFailure(serverType: ServerType.supabase),
        ),
      );
    });

    test('should relay Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.getAnonKeyFromServer(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenThrow(tUnknownRequestFailure);

      // act
      final result = await authenticationRepositoryImpl.getAnonKeyFromServer(
        serverUrl: tServerUrlString,
      );

      // assert
      expect(result, Left<Failure, bool>(tUnknownRequestFailure));
    });
  });

  group('getCurrentUserId', () {
    setUp(() {
      when(
        () => mockAuthRemoteDataSource.getCurrentUserId(),
      ).thenAnswer((_) async => tUserId);
    });

    test('should get the current user ID and return it', () async {
      // act
      final result = await authenticationRepositoryImpl.getCurrentUserId();

      // assert
      verify(() => mockAuthRemoteDataSource.getCurrentUserId());
      expect(result, const Right(tUserId));
    });

    test('should relay Failures', () async {
      // arrange
      when(
        () => mockAuthRemoteDataSource.getCurrentUserId(),
      ).thenThrow(const NotSignedInFailure());

      // act
      final result = await authenticationRepositoryImpl.getCurrentUserId();

      // assert
      expect(result, const Left<Failure, bool>(NotSignedInFailure()));
    });
  });

  group('deleteLocalStorage()', () {
    setUp(() {
      when(
        () => mockAuthLocalDataSource.deleteLocalStorage(),
      ).thenAnswer((_) => Future.value());
    });

    test('should delete the local storage and return None', () async {
      // act
      final result = await authenticationRepositoryImpl.deleteLocalStorage();

      // assert
      verify(() => mockAuthLocalDataSource.deleteLocalStorage());
      expect(result, const Right(None()));
    });

    test(
      'should convert PlatformException to StorageWriteFailure and return it',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.deleteLocalStorage(),
        ).thenThrow(tPlatformException);

        // act
        final result = await authenticationRepositoryImpl.deleteLocalStorage();

        // assert
        expect(result, const Left(StorageWriteFailure()));
      },
    );
  });
}
