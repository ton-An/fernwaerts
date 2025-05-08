import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late AuthenticationLocalDataSource authenticationLocalDataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    authenticationLocalDataSource = AuthLocalDataSourceImpl(
      secureStorage: mockSecureStorage,
    );
  });

  group('getSavedServerInfo()', () {
    setUp(() {
      when(
        () => mockSecureStorage.read(key: 'server_url'),
      ).thenAnswer((_) async => tServerUrlString);
      when(
        () => mockSecureStorage.read(key: 'anon_key'),
      ).thenAnswer((_) async => tAnonKey);
    });

    test('should read the server url key from storage', () async {
      // arrange

      // act
      await authenticationLocalDataSource.getSavedServerInfo();

      // assert
      verify(() => mockSecureStorage.read(key: 'server_url'));
    });

    test('should read the anon key from storage', () async {
      // arrange

      // act
      await authenticationLocalDataSource.getSavedServerInfo();

      // assert
      verify(() => mockSecureStorage.read(key: 'anon_key'));
    });

    test(
      'should throw a NoSavedServerFailure if the server url is null ',
      () async {
        // arrange
        when(
          () => mockSecureStorage.read(key: 'server_url'),
        ).thenAnswer((_) async => null);

        // act & assert
        expect(
          () async => await authenticationLocalDataSource.getSavedServerInfo(),
          throwsA(const NoSavedServerFailure()),
        );
      },
    );

    test(
      'should throw a NoSavedServerFailure if the anon key is null ',
      () async {
        // arrange
        when(
          () => mockSecureStorage.read(key: 'anon_key'),
        ).thenAnswer((_) async => null);

        // act & assert
        expect(
          () async => await authenticationLocalDataSource.getSavedServerInfo(),
          throwsA(const NoSavedServerFailure()),
        );
      },
    );

    test('should return the server info', () async {
      // arrange

      // act
      final result = await authenticationLocalDataSource.getSavedServerInfo();

      // assert
      expect(result, tServerInfo);
    });
  });

  group('removeSavedServer()', () {
    setUp(() {
      when(
        () => mockSecureStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) => Future.value());
    });
    test('should delete the saved server url', () async {
      // act
      await authenticationLocalDataSource.removeSavedServer();

      // assert
      verify(() => mockSecureStorage.delete(key: 'server_url'));
    });

    test('should delete the aon key', () async {
      // act
      await authenticationLocalDataSource.removeSavedServer();

      // assert
      verify(() => mockSecureStorage.delete(key: 'anon_key'));
    });
  });

  group('saveServerInfo()', () {
    setUp(() {
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should save the server url', () async {
      // act
      await authenticationLocalDataSource.saveServerInfo(
        serverInfo: tServerInfo,
      );

      // assert
      verify(
        () =>
            mockSecureStorage.write(key: 'server_url', value: tServerUrlString),
      );
    });

    test('should save the anon key', () async {
      // act
      await authenticationLocalDataSource.saveServerInfo(
        serverInfo: tServerInfo,
      );

      // assert
      verify(() => mockSecureStorage.write(key: 'anon_key', value: tAnonKey));
    });
  });

  group('getDeviceId()', () {
    setUp(() {
      when(
        () => mockSecureStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => tDeviceId);
    });

    test('should read the device id key from storage', () async {
      // act
      await authenticationLocalDataSource.getCurrentDeviceId();

      // assert
      verify(() => mockSecureStorage.read(key: 'device_id'));
    });

    test('should return the device id', () async {
      // act
      final result = await authenticationLocalDataSource.getCurrentDeviceId();

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
          () async => await authenticationLocalDataSource.getCurrentDeviceId(),
          throwsA(const NoSavedDeviceFailure()),
        );
      },
    );
  });
}
