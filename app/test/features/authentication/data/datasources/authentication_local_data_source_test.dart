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
}
