import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/email_address_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/email_address_taken_failure.dart';
import 'package:location_history/core/failures/authentication/email_rate_limit_failure.dart';
import 'package:location_history/core/failures/authentication/email_server_config_failure.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:location_history/core/failures/authentication/otp_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/passwords_must_differ.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/features/settings/data/repository_implementations/settings_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late SettingsRepositoryImpl settingsRepositoryImpl;
  late MockSettingsRemoteDataSource mockSettingsRemoteDataSource;
  late MockRepositoryFailureHandler mockRepositoryFailureHandler;

  setUp(() {
    mockSettingsRemoteDataSource = MockSettingsRemoteDataSource();
    mockRepositoryFailureHandler = MockRepositoryFailureHandler();
    settingsRepositoryImpl = SettingsRepositoryImpl(
      settingsRemoteDataSource: mockSettingsRemoteDataSource,
      repositoryFailureHandler: mockRepositoryFailureHandler,
    );
  });

  setUpAll(() {
    registerFallbackValue(tTimeoutClientException);
    registerFallbackValue(tStackTrace);
    registerFallbackValue(ServerType.supabase);
  });

  group('updateEmail', () {
    setUp(() {
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should update the email and return none', () async {
      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, const Right(None()));
      verify(() => mockSettingsRemoteDataSource.updateEmail(newEmail: tEmail));
    });

    test(
      'should return a failure if the email server config is invalid',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.updateEmail(
            newEmail: any(named: 'newEmail'),
          ),
        ).thenThrow(AuthApiException('Error sending email change email'));

        // act
        final result = await settingsRepositoryImpl.updateEmail(
          newEmail: tEmail,
        );

        // assert
        expect(result, const Left(EmailServerConfigFailure()));
      },
    );

    test('should return a failure if the email is invalid', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenThrow(AuthApiException('', code: 'validation_failed'));

      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, const Left(EmailAddressInvalidFailure()));
    });

    test('should return a failure if the email is already in use', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenThrow(AuthApiException('', code: 'email_exists'));

      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, const Left(EmailAddressTakenFailure()));
    });

    test(
      'should return a failure if the email rate limit is exceeded',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.updateEmail(
            newEmail: any(named: 'newEmail'),
          ),
        ).thenThrow(AuthApiException('', code: 'over_email_send_rate_limit'));

        // act
        final result = await settingsRepositoryImpl.updateEmail(
          newEmail: tEmail,
        );

        // assert
        expect(result, const Left(EmailRateLimitFailure()));
      },
    );

    test('should convert client exceptions to failures', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
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
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
      verify(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: tTimeoutClientException,
          stackTrace: any(named: 'stackTrace'),
          serverType: ServerType.supabase,
        ),
      );
    });
  });

  group('updatePassword', () {
    setUp(() {
      when(
        () => mockSettingsRemoteDataSource.updatePassword(
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should update the password and return none', () async {
      // act
      final result = await settingsRepositoryImpl.updatePassword(
        newPassword: tPassword,
      );

      // assert
      expect(result, const Right(None()));
      verify(
        () =>
            mockSettingsRemoteDataSource.updatePassword(newPassword: tPassword),
      );
    });

    test('should return a failure if the provided password is weak', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updatePassword(
          newPassword: any(named: 'newPassword'),
        ),
      ).thenThrow(
        AuthWeakPasswordException(message: '', statusCode: '', reasons: []),
      );

      // act
      final result = await settingsRepositoryImpl.updatePassword(
        newPassword: tPassword,
      );
      // assert
      expect(result, const Left(WeakPasswordFailure()));
    });

    test('should return a failure if otp reauthentication is needed', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updatePassword(
          newPassword: any(named: 'newPassword'),
        ),
      ).thenThrow(AuthApiException('', code: 'reauthentication_needed'));

      // act
      final result = await settingsRepositoryImpl.updatePassword(
        newPassword: tPassword,
      );
      // assert
      expect(result, const Left(NeedOtpReauthenticationFailure()));
    });

    test(
      'should return a failure if the new password is the same as the old one',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.updatePassword(
            newPassword: any(named: 'newPassword'),
          ),
        ).thenThrow(AuthApiException('', code: 'same_password'));

        // act
        final result = await settingsRepositoryImpl.updatePassword(
          newPassword: tPassword,
        );
        // assert
        expect(result, const Left(PasswordMustDifferFailure()));
      },
    );

    test('should return a failure if the otp is invalid', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updatePassword(
          newPassword: any(named: 'newPassword'),
        ),
      ).thenThrow(AuthApiException('', code: 'reauthentication_not_valid'));

      // act
      final result = await settingsRepositoryImpl.updatePassword(
        newPassword: tPassword,
      );

      // assert
      expect(result, const Left(OtpInvalidFailure()));
    });

    test('should convert client exceptions to failures', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updatePassword(
          newPassword: any(named: 'newPassword'),
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
      final result = await settingsRepositoryImpl.updatePassword(
        newPassword: tPassword,
      );
      // assert
      expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
      verify(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: tTimeoutClientException,
          stackTrace: any(named: 'stackTrace'),
          serverType: ServerType.supabase,
        ),
      );
    });
  });

  group('requestOtp', () {
    setUp(() {
      when(
        () => mockSettingsRemoteDataSource.requestOtp(),
      ).thenAnswer((_) => Future.value());
    });

    test('should request the otp and return none', () async {
      // act
      final result = await settingsRepositoryImpl.requestOtp();

      // assert
      expect(result, const Right(None()));
      verify(() => mockSettingsRemoteDataSource.requestOtp());
    });

    test(
      'should return a failure if the email rate limit is exceeded',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.requestOtp(),
        ).thenThrow(AuthApiException('', code: 'over_email_send_rate_limit'));

        // act
        final result = await settingsRepositoryImpl.requestOtp();

        // assert
        expect(result, const Left(EmailRateLimitFailure()));
      },
    );

    test('should convert client exceptions to failures', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.requestOtp(),
      ).thenThrow(tTimeoutClientException);
      when(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: any(named: 'clientException'),
          stackTrace: any(named: 'stackTrace'),
          serverType: any(named: 'serverType'),
        ),
      ).thenReturn(SendTimeoutFailure(serverType: ServerType.supabase));

      // act
      final result = await settingsRepositoryImpl.requestOtp();

      // assert
      expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
      verify(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: tTimeoutClientException,
          stackTrace: any(named: 'stackTrace'),
          serverType: ServerType.supabase,
        ),
      );
    });
  });

  group('inviteNewUser', () {
    setUp(() {
      when(
        () => mockSettingsRemoteDataSource.inviteNewUser(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => Future.value());
    });

    test('should invite the new user and return none', () async {
      // act
      final result = await settingsRepositoryImpl.inviteNewUser(email: tEmail);

      // assert
      expect(result, const Right(None()));
    });

    test('should convert client exceptions to failures', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.inviteNewUser(
          email: any(named: 'email'),
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
      final result = await settingsRepositoryImpl.inviteNewUser(email: tEmail);

      // assert
      expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
      verify(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: tTimeoutClientException,
          stackTrace: any(named: 'stackTrace'),
          serverType: ServerType.supabase,
        ),
      );
    });

    test(
      'should return a failure if there was an error sending the email',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.inviteNewUser(
            email: any(named: 'email'),
          ),
        ).thenThrow(
          const FunctionException(
            status: 500,
            details: {
              'message': 'Error sending invite email',
              'code': 'unexpected_failure',
            },
          ),
        );

        // act
        final result = await settingsRepositoryImpl.inviteNewUser(
          email: tEmail,
        );

        // assert
        expect(result, const Left(EmailServerConfigFailure()));
      },
    );

    test('should return a failure if the email address is invalid', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.inviteNewUser(
          email: any(named: 'email'),
        ),
      ).thenThrow(
        const FunctionException(
          status: 400,
          details: {
            'code': 'validation_failed',
            'message': 'Invalid email address',
          },
        ),
      );

      // act
      final result = await settingsRepositoryImpl.inviteNewUser(email: tEmail);

      // assert
      expect(result, const Left(EmailAddressInvalidFailure()));
    });

    test(
      'should return a failure if the email address is already in use',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.inviteNewUser(
            email: any(named: 'email'),
          ),
        ).thenThrow(
          const FunctionException(
            status: 400,
            details: {
              'code': 'email_exists',
              'message': 'Email address already in use',
            },
          ),
        );

        // act
        final result = await settingsRepositoryImpl.inviteNewUser(
          email: tEmail,
        );

        // assert
        expect(result, const Left(EmailAddressTakenFailure()));
      },
    );

    test(
      'should return a failure if the email rate limit is exceeded',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.inviteNewUser(
            email: any(named: 'email'),
          ),
        ).thenThrow(
          const FunctionException(
            status: 400,
            details: {
              'code': 'over_email_send_rate_limit',
              'message': 'Email rate limit exceeded',
            },
          ),
        );

        // act
        final result = await settingsRepositoryImpl.inviteNewUser(
          email: tEmail,
        );

        // assert
        expect(result, const Left(EmailRateLimitFailure()));
      },
    );
  });
}
