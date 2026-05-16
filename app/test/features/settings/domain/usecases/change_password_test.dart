import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/features/settings/domain/usecases/change_password.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late ChangePassword changePassword;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    changePassword = ChangePassword(settingsRepository: mockSettingsRepository);
  });

  setUp(() {
    when(
      () => mockSettingsRepository.updatePassword(
        newPassword: any(named: 'newPassword'),
        otp: any(named: 'otp'),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  test('should change the users password and return none', () async {
    // act
    final result = await changePassword(newPassword: tPassword, otp: tOtp);

    // assert
    expect(result, const Right(None()));
    verify(
      () => mockSettingsRepository.updatePassword(
        newPassword: tPassword,
        otp: tOtp,
      ),
    );
  });

  test('should relay failures from changing the password', () async {
    // arrange
    when(
      () => mockSettingsRepository.updatePassword(
        newPassword: any(named: 'newPassword'),
        otp: any(named: 'otp'),
      ),
    ).thenAnswer(
      (_) async => Left(SendTimeoutFailure(serverType: ServerType.supabase)),
    );

    // act
    final result = await changePassword(newPassword: tPassword, otp: tOtp);

    // assert
    expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
  });

  group('reauthenticate', () {
    setUp(() {
      when(
        () => mockSettingsRepository.updatePassword(
          newPassword: any(named: 'newPassword'),
          otp: any(named: 'otp'),
        ),
      ).thenAnswer((_) async => const Left(NeedOtpReauthenticationFailure()));
    });

    test(
      'should request otp when the user needs to reauthenticate and return a need otp reauthentication failure',
      () async {
        // arrange
        when(
          () => mockSettingsRepository.requestOtp(),
        ).thenAnswer((_) async => const Right(None()));

        // act
        final result = await changePassword(newPassword: tPassword, otp: tOtp);

        // assert
        expect(result, const Left(NeedOtpReauthenticationFailure()));
      },
    );

    test('should relay failures from requesting otp', () async {
      // assert
      when(() => mockSettingsRepository.requestOtp()).thenAnswer(
        (_) async => Left(SendTimeoutFailure(serverType: ServerType.supabase)),
      );

      // act
      final result = await changePassword(newPassword: tPassword, otp: tOtp);

      // assert
      expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
    });
  });
}
