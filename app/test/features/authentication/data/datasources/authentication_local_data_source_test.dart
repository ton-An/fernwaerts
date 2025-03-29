import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late AuthenticationLocalDataSource authenticationLocalDataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    authenticationLocalDataSource = AuthLocalDataSourceImpl(
      secureStorage: mockSecureStorage,
    );
  });

  group('getSavedServerUrl()', () {
    test('should read the server url key from storage and return it', () async {
      // arrange
      when(
        () => mockSecureStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => tServerUrlString);

      // act
      final result = await authenticationLocalDataSource.getSavedServerUrl();

      // assert
      verify(() => mockSecureStorage.read(key: 'server_url'));
      expect(result, tServerUrlString);
    });
  });

  group('removeSavedServer()', () {
    test('should delete the saved server url', () async {
      // arrange
      when(
        () => mockSecureStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) => Future.value());

      // act
      await authenticationLocalDataSource.removeSavedServer();

      // assert
      verify(() => mockSecureStorage.delete(key: 'server_url'));
    });
  });

  group('saveServerUrl()', () {
    test('should save the server url', () async {
      // arrange
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) => Future.value());

      // act
      await authenticationLocalDataSource.saveServerUrl(
        serverUrl: tServerUrlString,
      );

      // assert
      verify(
        () =>
            mockSecureStorage.write(key: 'server_url', value: tServerUrlString),
      );
    });
  });
}
