import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SignOut signOut;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signOut = SignOut(authenticationRepository: mockAuthenticationRepository);

    when(
      () => mockAuthenticationRepository.signOut(),
    ).thenAnswer((_) => Future.value());
    when(
      () => mockAuthenticationRepository.removeSavedServer(),
    ).thenAnswer((_) => Future.value(const Right(None())));
  });

  /// should sign out the user
  /// should remove the saved server and return None
  /// should relay Failures from removing the saved server

  test('should sign out the user', () async {
    // act
    final result = await signOut();

    // assert
    verify(() => mockAuthenticationRepository.signOut());
    expect(result, const Right(None()));
  });

  test('should remove the saved server and return None', () async {
    // act
    final result = await signOut();

    // assert
    verify(() => mockAuthenticationRepository.removeSavedServer());
    expect(result, const Right(None()));
  });

  test('should relay Failures from removing the saved server', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.removeSavedServer(),
    ).thenAnswer((_) => Future.value(const Left(StorageWriteFailure())));

    // act
    final result = await signOut();

    // assert
    expect(result, const Left(StorageWriteFailure()));
  });
}
