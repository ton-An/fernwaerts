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

  group('hasServerConnectionSaved()', () {
    test(
      'should read the server url key from storage and return true if the server url key is found in storage',
      () async {
        // arrange
        when(
          () => mockSecureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => tServerUrlString);

        // act
        final result =
            await authenticationLocalDataSource.hasServerConnectionSaved();

        // assert
        verify(() => mockSecureStorage.read(key: 'server_url'));
        expect(result, true);
      },
    );

    test(
      'should return false if the server url key is not found in storage',
      () async {
        // arrange
        when(
          () => mockSecureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => null);

        // act
        final result =
            await authenticationLocalDataSource.hasServerConnectionSaved();

        // assert
        expect(result, false);
      },
    );
  });
}
