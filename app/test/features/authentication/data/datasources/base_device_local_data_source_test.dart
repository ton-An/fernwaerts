import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/features/authentication/data/datasources/base_device_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late BaseDeviceLocalDataSource baseDeviceLocalDataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    baseDeviceLocalDataSource = BaseDeviceLocalDataSourceImpl(
      secureStorage: mockSecureStorage,
    );
  });

  group('getDeviceIdFromStorage()', () {
    setUp(() {
      when(
        () => mockSecureStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => tDeviceId);
    });

    test('should read the device id key from storage', () async {
      // act
      await baseDeviceLocalDataSource.getDeviceIdFromStorage();

      // assert
      verify(() => mockSecureStorage.read(key: 'device_id'));
    });

    test('should return the device id', () async {
      // act
      final result = await baseDeviceLocalDataSource.getDeviceIdFromStorage();

      // assert
      expect(result, tDeviceId);
    });

    test(
      'should throw a no saved device failure if the device id is null',
      () async {
        // arrange
        when(
          () => mockSecureStorage.read(key: 'device_id'),
        ).thenAnswer((_) async => null);

        // act & assert
        expect(
          () async => await baseDeviceLocalDataSource.getDeviceIdFromStorage(),
          throwsA(const NoSavedDeviceFailure()),
        );
      },
    );
  });
}
