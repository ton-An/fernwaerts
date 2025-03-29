import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/misc/url_path_constants.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

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

    when(() => mockSupabaseHandler.getClient()).thenReturn(mockSupabaseClient);
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
  });

  tearDown(() {
    mockSupabaseHttpClient.reset();
  });

  tearDownAll(() {
    mockSupabaseHttpClient.close();
  });

  group('isServerConnectionValid()', () {
    setUp(() async {
      await mockSupabaseClient
          .from('public_settings')
          .insert(tPublicSettingsMap);
    });

    test('should check if the connection to the server is valid', () async {
      // act & assert
      try {
        await authRemoteDataSourceImpl.isServerConnectionValid();
      } catch (e) {
        fail("Select operation on 'public_settings' db table failed\n$e");
      }
    });
  });

  group('isServerSetUp()', () {
    setUp(() async {
      await mockSupabaseClient
          .from('public_settings')
          .insert(tPublicSettingsMap);
    });

    test(
      'should check if the server is set up and return the boolean value',
      () async {
        // act & assert
        try {
          final result = await authRemoteDataSourceImpl.isServerSetUp();

          expect(result, true);
        } catch (e) {
          fail("Select operation on 'public_settings' db table failed\n$e");
        }
      },
    );
  });

  group('initializeServerConnection()', () {
    setUp(() {
      when(
        () =>
            mockSupabaseHandler.initialize(serverUrl: any(named: 'serverUrl')),
      ).thenAnswer((_) async => tMockSupabase);
      when(
        () => mockSupabaseHandler.dispose(),
      ).thenAnswer((_) => Future.value());
    });

    test('should dispose the old server connection', () async {
      // act
      await authRemoteDataSourceImpl.initializeServerConnection(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(() => mockSupabaseHandler.dispose());
    });

    test('should initialize the new server connection', () async {
      // act
      await authRemoteDataSourceImpl.initializeServerConnection(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(() => mockSupabaseHandler.initialize(serverUrl: tServerUrlString));
    });

    test(
      'should continue with initialization if dispose throws an exception (happens if there is no previous connection)',
      () async {
        when(() => mockSupabaseHandler.dispose()).thenThrow(Exception());
        // act
        await authRemoteDataSourceImpl.initializeServerConnection(
          serverUrl: tServerUrlString,
        );

        // assert
        verify(
          () => mockSupabaseHandler.initialize(serverUrl: tServerUrlString),
        );
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

    test('should return false if the current session is null', () {
      // act
      final result = authRemoteDataSourceImpl.isSignedIn();

      // assert
      expect(result, false);
    });
  });
}
