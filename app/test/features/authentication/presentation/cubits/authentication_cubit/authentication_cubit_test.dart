import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_supabase_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_server_set_up.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_state.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures.dart';

class MockInitializeNewSupabaseConnection extends Mock
    implements InitializeNewSupabaseConnection {}

class MockIsServerSetUp extends Mock implements IsServerSetUp {}

class MockSignUpInitialAdmin extends Mock implements SignUpInitialAdmin {}

class MockSignIn extends Mock implements SignIn {}

class MockRequestNecessaryPermissions extends Mock
    implements RequestNecessaryPermissions {}

class MockInitBackgroundLocationTracking extends Mock
    implements InitBackgroundLocationTracking {}

void main() {
  late AuthenticationCubit cubit;
  late MockInitializeNewSupabaseConnection mockInitializeNewSupabaseConnection;
  late MockIsServerSetUp mockIsServerSetUp;
  late MockSignUpInitialAdmin mockSignUpInitialAdmin;
  late MockSignIn mockSignIn;
  late MockRequestNecessaryPermissions mockRequestNecessaryPermissions;
  late MockInitBackgroundLocationTracking mockInitBackgroundLocationTracking;

  setUpAll(() {
    registerFallbackValue(tSupabaseInfo);
  });

  setUp(() {
    mockInitializeNewSupabaseConnection = MockInitializeNewSupabaseConnection();
    mockIsServerSetUp = MockIsServerSetUp();
    mockSignUpInitialAdmin = MockSignUpInitialAdmin();
    mockSignIn = MockSignIn();
    mockRequestNecessaryPermissions = MockRequestNecessaryPermissions();
    mockInitBackgroundLocationTracking = MockInitBackgroundLocationTracking();

    cubit = AuthenticationCubit(
      initializeNewSupabaseConnection: mockInitializeNewSupabaseConnection,
      isServerSetUp: mockIsServerSetUp,
      signUpInitialAdmin: mockSignUpInitialAdmin,
      signInUsecase: mockSignIn,
      requestNecessaryPermissions: mockRequestNecessaryPermissions,
      initBackgroundLocationTracking: mockInitBackgroundLocationTracking,
    );

    when(
      () => mockInitializeNewSupabaseConnection(
        serverUrl: any(named: 'serverUrl'),
      ),
    ).thenAnswer((_) async => const Right(tSupabaseInfo));
    when(() => mockIsServerSetUp()).thenAnswer((_) async => const Right(true));
    when(
      () => mockSignUpInitialAdmin(
        supabaseInfo: any(named: 'supabaseInfo'),
        username: any(named: 'username'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        repeatedPassword: any(named: 'repeatedPassword'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockSignIn(
        supabaseInfo: any(named: 'supabaseInfo'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockRequestNecessaryPermissions(),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockInitBackgroundLocationTracking(),
    ).thenAnswer((_) async => const Right(None()));
  });

  tearDown(() async {
    await cubit.close();
  });

  group('toAuthDetails', () {
    test('routes to login when the server is already set up', () async {
      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthenticationLoading>(), isA<EnterLoginInfo>()]),
      );

      // act
      cubit.toAuthDetails(serverUrl: tServerUrlString);

      // assert
      await expectedStates;
    });

    test(
      'routes to initial admin sign-up when the server is not set up',
      () async {
        // arrange
        when(
          () => mockIsServerSetUp(),
        ).thenAnswer((_) async => const Right(false));

        // arrange
        final expectedStates = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AuthenticationLoading>(),
            isA<EnterAdminSignUpInfo>(),
          ]),
        );

        // act
        cubit.toAuthDetails(serverUrl: tServerUrlString);

        // assert
        await expectedStates;
      },
    );

    test('emits a failure when server initialization fails', () async {
      // arrange
      when(
        () => mockInitializeNewSupabaseConnection(
          serverUrl: any(named: 'serverUrl'),
        ),
      ).thenAnswer((_) async => const Left(StorageWriteFailure()));

      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthenticationLoading>(),
          isA<AuthenticationFailure>().having(
            (state) => state.failure,
            'failure',
            const StorageWriteFailure(),
          ),
        ]),
      );

      // act
      cubit.toAuthDetails(serverUrl: tServerUrlString);

      // assert
      await expectedStates;
    });
  });

  group('signIn', () {
    test('emits success and requests permissions', () async {
      // arrange
      cubit.supabaseInfo = tSupabaseInfo;

      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthenticationLoading>(),
          isA<AuthenticationSuccess>(),
        ]),
      );

      // act
      cubit.signIn(email: tEmail, password: tPassword);

      // assert
      await expectedStates;
      verify(() => mockRequestNecessaryPermissions()).called(1);
    });
  });

  group('signUpAdmin', () {
    test('emits success and starts permission setup', () async {
      // arrange
      cubit.supabaseInfo = tSupabaseInfo;

      // arrange
      final expectedStates = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthenticationLoading>(),
          isA<AuthenticationSuccess>(),
        ]),
      );

      // act
      cubit.signUpAdmin(
        username: tUsername,
        email: tEmail,
        password: tPassword,
        repeatedPassword: tPassword,
      );

      // assert
      await expectedStates;
      verify(() => mockRequestNecessaryPermissions()).called(1);
    });
  });
}
