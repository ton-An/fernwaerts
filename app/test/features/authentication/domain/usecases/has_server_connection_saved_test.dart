import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/has_server_connection_saved.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late HasServerConnectionSaved hasServerConnectionSaved;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    hasServerConnectionSaved = HasServerConnectionSaved(
      authenticationRepository: mockAuthenticationRepository,
    );

    when(
      () => mockAuthenticationRepository.getSavedServerUrl(),
    ).thenAnswer((_) async => Right(tServerUrlString));
  });

  test(
    'should get the saved server url and return true if the url is not null',
    () async {
      // act
      final result = await hasServerConnectionSaved();

      // assert
      verify(() => mockAuthenticationRepository.getSavedServerUrl());
      expect(result, Right(true));
    },
  );

  test(
    'should get the saved server url and return false if the url is null',
    () async {
      // arrange
      when(
        () => mockAuthenticationRepository.getSavedServerUrl(),
      ).thenAnswer((_) async => Right(null));

      // act
      final result = await hasServerConnectionSaved();

      // assert
      expect(result, Right(false));
    },
  );

  test('should relay Failures from getting the saved server url', () async {
    // arrange
    when(
      () => mockAuthenticationRepository.getSavedServerUrl(),
    ).thenAnswer((_) async => Left(StorageReadFailure()));

    // act
    final result = await hasServerConnectionSaved();

    // assert
    expect(result, Left(StorageReadFailure()));
  });
}
