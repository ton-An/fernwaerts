import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/authentication/password_mismatch_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late SignUpInitialAdmin signUpInitialAdmin;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signUpInitialAdmin = SignUpInitialAdmin(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.signUpInitialAdmin(
        serverUrl: any(named: "serverUrl"),
        username: any(named: "username"),
        email: any(named: "email"),
        password: any(named: "password"),
      ),
    ).thenAnswer((_) async => Right(None()));
  });

  test(
    "should return a PasswordMismatchFailure if the passwords do not match",
    () async {
      // act
      final result = await signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
        repeatedPassword: "mismatched password",
      );

      // assert
      expect(result, Left(PasswordMismatchFailure()));
    },
  );

  test("should sign up the initial admin user and return None", () async {
    // act
    final result = await signUpInitialAdmin(
      serverUrl: tServerUrlString,
      username: tUsername,
      email: tEmail,
      password: tPassword,
      repeatedPassword: tPassword,
    );

    // assert
    expect(result, Right(None()));
  });

  test(
    "should relay Failures if any occur during the sign up process",
    () async {
      when(
        () => mockAuthenticationRepository.signUpInitialAdmin(
          serverUrl: any(named: "serverUrl"),
          username: any(named: "username"),
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenAnswer((_) async => Left(WeakPasswordFailure()));

      // act
      final result = await signUpInitialAdmin(
        serverUrl: tServerUrlString,
        username: tUsername,
        email: tEmail,
        password: tPassword,
        repeatedPassword: tPassword,
      );

      // assert
      expect(result, Left(WeakPasswordFailure()));
    },
  );
}
