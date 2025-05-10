import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SignOut signOut;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockLocationTrackingRepository mockLocationTrackingRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockLocationTrackingRepository = MockLocationTrackingRepository();
    signOut = SignOut(
      authenticationRepository: mockAuthenticationRepository,
      locationTrackingRepository: mockLocationTrackingRepository,
    );

    when(
      () => mockAuthenticationRepository.signOut(),
    ).thenAnswer((_) => Future.value());
    when(
      () => mockLocationTrackingRepository.stopTracking(),
    ).thenAnswer((_) => Future.value());
    when(
      () => mockAuthenticationRepository.deleteLocalStorage(),
    ).thenAnswer((_) => Future.value(const Right(None())));
    when(
      () => mockAuthenticationRepository.deleteLocalDBCache(),
    ).thenAnswer((_) => Future.value());
  });

  test('should sign out the user', () async {
    // act
    final result = await signOut();

    // assert
    verify(() => mockAuthenticationRepository.signOut());
    expect(result, const Right(None()));
  });

  test('should stop location tracking', () async {
    // act
    await signOut();

    // assert
    verify(() => mockLocationTrackingRepository.stopTracking());
  });

  test('should delete the local DB cache ', () async {
    // act
    await signOut();

    // assert
    verify(() => mockAuthenticationRepository.deleteLocalDBCache());
  });

  test('should delete the local storage and return None', () async {
    // act
    final result = await signOut();

    // assert
    verify(() => mockAuthenticationRepository.deleteLocalStorage());
    expect(result, const Right(None()));
  });

  test('should relay Failures from deleting the local storage', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.deleteLocalStorage(),
    ).thenAnswer((_) => Future.value(const Left(StorageWriteFailure())));

    // act
    final result = await signOut();

    // assert
    expect(result, const Left(StorageWriteFailure()));
  });
}
