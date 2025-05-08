import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/misc/url_path_constants.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late MockSupabaseHandler mockSupabaseHandler;
  late MockServerRemoteHandler mockServerRemoteHandler;

  late MockSupabaseHttpClient mockSupabaseHttpClient;
  late SupabaseClient mockSupabaseClient;

  setUp(() {
    mockSupabaseHandler = MockSupabaseHandler();
    mockServerRemoteHandler = MockServerRemoteHandler();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(
      serverRemoteHandler: mockServerRemoteHandler,
      supabaseHandler: mockSupabaseHandler,
    );

    mockSupabaseHttpClient = MockSupabaseHttpClient();
    mockSupabaseClient = SupabaseClient(
      'http://tedmosbyisnotajerk.com/',
      'supabaseKey',
      httpClient: mockSupabaseHttpClient,
    );

    when(
      () => mockSupabaseHandler.client,
    ).thenAnswer((_) async => mockSupabaseClient);
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
    registerFallbackValue(tServerInfo);
  });

  tearDown(() {
    mockSupabaseHttpClient.reset();
  });

  tearDownAll(() {
    mockSupabaseHttpClient.close();
  });

  group('isServerConnectionValid()', () {
    setUp(() {
      when(
        () => mockServerRemoteHandler.get(url: any(named: 'url')),
      ).thenAnswer((_) async => tGetAnonKeyResponseData);
    });

    test('should check if the connection to the server is valid', () async {
      // act
      await authRemoteDataSourceImpl.isServerConnectionValid(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(
        () => mockServerRemoteHandler.get(
          url: Uri.parse(tServerUrlString + UrlPathConstants.health),
        ),
      );
    });
  });

  group('isServerSetUp()', () {
    setUp(() async {
      await mockSupabaseClient.from('public_info').insert(tPublicSettingsMap);
    });

    test(
      'should check if the server is set up and return the boolean value',
      () async {
        // act & assert
        try {
          final result = await authRemoteDataSourceImpl.isServerSetUp();

          expect(result, true);
        } catch (e) {
          fail("Select operation on 'public_info' db table failed\n$e");
        }
      },
    );
  });

  group('initializeServerConnection()', () {
    setUp(() {
      when(
        () => mockSupabaseHandler.initialize(
          serverInfo: any(named: 'serverInfo'),
        ),
      ).thenAnswer((_) async => tMockSupabase);
      when(
        () => mockSupabaseHandler.dispose(),
      ).thenAnswer((_) => Future.value());
    });

    test('should dispose the old server connection', () async {
      // act
      await authRemoteDataSourceImpl.initializeServerConnection(
        serverInfo: tServerInfo,
      );

      // assert
      verify(() => mockSupabaseHandler.dispose());
    });

    test('should initialize the new server connection', () async {
      // act
      await authRemoteDataSourceImpl.initializeServerConnection(
        serverInfo: tServerInfo,
      );

      // assert
      verify(() => mockSupabaseHandler.initialize(serverInfo: tServerInfo));
    });

    test(
      'should continue with initialization if dispose throws an exception (happens if there is no previous connection)',
      () async {
        when(() => mockSupabaseHandler.dispose()).thenThrow(Exception());
        // act
        await authRemoteDataSourceImpl.initializeServerConnection(
          serverInfo: tServerInfo,
        );

        // assert
        verify(() => mockSupabaseHandler.initialize(serverInfo: tServerInfo));
      },
    );
  });

  group('signUpInitialAdmin()', () {
    setUp(() {
      when(
        () => mockServerRemoteHandler.post(
          url: any(named: 'url'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => tNullResponseData);
    });

    test('should sign up the initial admin', () async {
      // act
      await authRemoteDataSourceImpl.signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(
        () => mockServerRemoteHandler.post(
          url: Uri.parse(
            tServerUrlString + UrlPathConstants.signUpInitialAdmin,
          ),
          body: {'username': tUsername, 'email': tEmail, 'password': tPassword},
        ),
      );
    });
  });

  group('isSignedIn()', () {
    // ToDo: uncomment this test when the mock_supabase_http_client package supports mocking auth
    //   test('should return true if there is a current session', () async {
    //     // arrange
    //     await mockSupabaseClient.auth.signInWithPassword(
    //       email: tEmail,
    //       password: tPassword,
    //     );

    //     // act
    //     final result = authRemoteDataSourceImpl.isSignedIn();

    //     // assert
    //     expect(result, true);
    //   });

    test('should return false if the current session is null', () async {
      // act
      final result = await authRemoteDataSourceImpl.isSignedIn();

      // assert
      expect(result, false);
    });
  });

  group('authenticationStateStream()', () {
    // ToDo: uncomment this test when the mock_supabase_http_client package supports mocking auth
    // test('should convert AuthState to AuthenticationState and yield it', () {});
  });

  group('signOut()', () {
    // ToDo: uncomment this test when the mock_supabase_http_client package supports mocking auth
    // test('should sign out the user', () {});
  });

  group('getAnonKeyFromServer()', () {
    setUp(() {
      when(
        () => mockServerRemoteHandler.get(url: any(named: 'url')),
      ).thenAnswer((_) async => tGetAnonKeyResponseData);
    });

    test('should get the anon key from the server', () async {
      // act
      await authRemoteDataSourceImpl.getAnonKeyFromServer(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(
        () => mockServerRemoteHandler.get(
          url: Uri.parse(tServerUrlString + UrlPathConstants.getAnonKey),
        ),
      );
    });
  });

  group('getCurrentUserId', () {
    // ToDo: uncomment this test when the mock_supabase_http_client package supports mocking auth
    // test('should return the current user id', () async {
    //   // act
    //   final result = await authRemoteDataSourceImpl.getCurrentUserId();

    //   // assert
    //   expect(result, tSupabaseUser.id);
    // });

    test('should throw a not signed in failure if the user is null', () async {
      // act & assert
      expect(
        () async => await authRemoteDataSourceImpl.getCurrentUserId(),
        throwsA(isA<NotSignedInFailure>()),
      );
    });
  });
}
