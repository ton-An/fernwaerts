import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/storage/database_read_failure.dart';
import 'package:location_history/features/settings/domain/usecases/watch_users.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late WatchUsers watchUsers;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    watchUsers = WatchUsers(settingsRepository: mockSettingsRepository);
  });

  test('should watch users from the repository', () async {
    // arrange
    when(
      () => mockSettingsRepository.watchUsers(),
    ).thenAnswer((_) => Stream.value(const Right(tUsers)));

    // act
    final result = watchUsers();

    // assert
    await expectLater(result, emits(const Right(tUsers)));
    verify(() => mockSettingsRepository.watchUsers());
  });

  test('should relay failures from watching users', () {
    // arrange
    when(
      () => mockSettingsRepository.watchUsers(),
    ).thenAnswer((_) => Stream.value(const Left(DatabaseReadFailure())));

    // act
    final result = watchUsers();

    // assert
    expect(result, emits(const Left(DatabaseReadFailure())));
  });
}
