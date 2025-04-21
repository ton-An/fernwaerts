import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/password_mismatch_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late SignUpInitialAdmin signUpInitialAdmin;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockSignIn mockSignIn;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockSignIn = MockSignIn();
    signUpInitialAdmin = SignUpInitialAdmin(
      authenticationRepository: mockAuthenticationRepository,
      signIn: mockSignIn,
    );

    when(
      () => mockAuthenticationRepository.signUpInitialAdmin(
        serverUrl: any(named: 'serverUrl'),
        username: any(named: 'username'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockSignIn(
        serverInfo: any(named: 'serverInfo'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  setUpAll(() {
    registerFallbackValue(tServerInfo);
  });

  test(
    'should return a PasswordMismatchFailure if the passwords do not match',
    () async {
      // act
      final result = await signUpInitialAdmin(
        serverInfo: tServerInfo,
        username: tUsername,
        email: tEmail,
        password: tPassword,
        repeatedPassword: 'mismatched password',
      );

      // assert
      expect(result, const Left(PasswordMismatchFailure()));
    },
  );

  test('should sign up the initial admin user', () async {
    // act
    await signUpInitialAdmin(
      serverInfo: tServerInfo,
      username: tUsername,
      email: tEmail,
      password: tPassword,
      repeatedPassword: tPassword,
    );

    // assert
    verify(
      () => mockAuthenticationRepository.signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
      ),
    );
  });

  test(
    'should relay Failures if any occur during the sign up process',
    () async {
      when(
        () => mockAuthenticationRepository.signUpInitialAdmin(
          serverUrl: any(named: 'serverUrl'),
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(WeakPasswordFailure()));

      // act
      final result = await signUpInitialAdmin(
        serverInfo: tServerInfo,
        username: tUsername,
        email: tEmail,
        password: tPassword,
        repeatedPassword: tPassword,
      );

      // assert
      expect(result, const Left(WeakPasswordFailure()));
    },
  );

  test('should sign in the newly created user and return None', () async {
    // act
    final result = await signUpInitialAdmin(
      serverInfo: tServerInfo,
      username: tUsername,
      email: tEmail,
      password: tPassword,
      repeatedPassword: tPassword,
    );

    // assert
    verify(
      () => mockSignIn(
        serverInfo: tServerInfo,
        email: tEmail,
        password: tPassword,
      ),
    );
    expect(result, const Right(None()));
  });

  test('should relay Failures from signing in', () async {
    when(
      () => mockSignIn(
        serverInfo: tServerInfo,
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(SendTimeoutFailure()));

    // act
    final result = await signUpInitialAdmin(
      serverInfo: tServerInfo,
      username: tUsername,
      email: tEmail,
      password: tPassword,
      repeatedPassword: tPassword,
    );

    // assert
    expect(result, const Left(SendTimeoutFailure()));
  });
}
