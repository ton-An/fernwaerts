import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_supabase_connection.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late InitializeNewSupabaseConnection initializeNewSupabaseConnection;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    initializeNewSupabaseConnection = InitializeNewSupabaseConnection(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.initializeSupabaseConnection(
        supabaseInfo: any(named: 'supabaseInfo'),
      ),
    ).thenAnswer((_) async => const Right(None()));

    when(
      () => mockAuthenticationRepository.getAnonKeyFromServer(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(tAnonKey));

    when(
      () => mockAuthenticationRepository.isServerConnectionValid(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tSupabaseInfo);
  });

  test('should check if server connection is valid', () async {
    // act
    await initializeNewSupabaseConnection(serverUrl: tServerUrlString);

    // assert
    verify(
      () => mockAuthenticationRepository.isServerConnectionValid(
        serverUrl: any(named: 'serverUrl'),
      ),
    );
  });

  test(
    'should relay Failures if server is not reachable, for whatever reason',
    () async {
      // arrange
      when(
        () => mockAuthenticationRepository.isServerConnectionValid(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenAnswer((_) async => const Left(InvalidUrlFormatFailure()));

      // act
      final result = await initializeNewSupabaseConnection(
        serverUrl: tServerUrlString,
      );

      // assert
      expect(result, const Left(InvalidUrlFormatFailure()));
    },
  );

  test('should get the anon key from the server', () async {
    // act
    await initializeNewSupabaseConnection(serverUrl: tServerUrlString);

    // assert
    verify(
      () => mockAuthenticationRepository.getAnonKeyFromServer(
        serverUrl: tServerUrlString,
      ),
    );
  });

  test('should relay Failures if getting the anon key fails', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getAnonKeyFromServer(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Left(ConnectionFailure()));

    // act
    final result = await initializeNewSupabaseConnection(
      serverUrl: tServerUrlString,
    );

    // assert
    expect(result, const Left(ConnectionFailure()));
  });

  test(
    'should initialize the connection to the server and return the server info',
    () async {
      // act
      final result = await initializeNewSupabaseConnection(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(
        () => mockAuthenticationRepository.initializeSupabaseConnection(
          supabaseInfo: tSupabaseInfo,
        ),
      );
      expect(result, const Right(tSupabaseInfo));
    },
  );

  test('should relay Failures of connection initialization', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.initializeSupabaseConnection(
        supabaseInfo: any(named: 'supabaseInfo'),
      ),
    ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

    // act
    final result = await initializeNewSupabaseConnection(
      serverUrl: tServerUrlString,
    );

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });
}
