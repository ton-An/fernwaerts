import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/has_server_connection_saved.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late HasServerConnectionSaved hasServerConnectionSaved;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    hasServerConnectionSaved = HasServerConnectionSaved(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.getSavedServerInfo(),
    ).thenAnswer((_) async => const Right(tServerInfo));
  });

  test(
    'should get the saved server info and return true if the url is not null',
    () async {
      // act
      final result = await hasServerConnectionSaved();

      // assert
      verify(() => mockAuthenticationRepository.getSavedServerInfo());
      expect(result, const Right(true));
    },
  );

  test(
    'should get the saved server info and return false if a NoSavedServerFailure is returned',
    () async {
      // arrange
      when(
        () => mockAuthenticationRepository.getSavedServerInfo(),
      ).thenAnswer((_) async => const Left(NoSavedServerFailure()));

      // act
      final result = await hasServerConnectionSaved();

      // assert
      expect(result, const Right(false));
    },
  );

  test('should relay Failures from getting the saved server info', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getSavedServerInfo(),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await hasServerConnectionSaved();

    // assert
    expect(result, const Left(StorageReadFailure()));
  });
}
