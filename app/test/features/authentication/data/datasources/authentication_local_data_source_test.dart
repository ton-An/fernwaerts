import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/misc/app_file_constants.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late AuthenticationLocalDataSource authenticationLocalDataSource;
  late MockFlutterSecureStorage mockSecureStorage;
  late MockSupabaseHandler mockSupabaseHandler;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    mockSupabaseHandler = MockSupabaseHandler();
    authenticationLocalDataSource = AuthLocalDataSourceImpl(
      secureStorage: mockSecureStorage,
      supabaseHandler: mockSupabaseHandler,
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
      when(
        () => mockSecureStorage.read(key: 'powersync_url'),
      ).thenAnswer((_) async => tPowersyncUrl);
    });

    test('should read and return the saved server info from storage', () async {
      // act
      final result = await authenticationLocalDataSource.getSavedServerInfo();

      // assert
      verify(() => mockSecureStorage.read(key: 'server_url'));
      verify(() => mockSecureStorage.read(key: 'anon_key'));
      verify(() => mockSecureStorage.read(key: 'powersync_url'));
      expect(result, tServerInfo);
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
      'should throw a NoSavedServerFailure if the powersync url is null ',
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

    test(
      'should throw a NoSavedServerFailure if the anon key is null ',
      () async {
        // arrange
        when(
          () => mockSecureStorage.read(key: 'powersync_url'),
        ).thenAnswer((_) async => null);

        // act & assert
        expect(
          () async => await authenticationLocalDataSource.getSavedServerInfo(),
          throwsA(const NoSavedServerFailure()),
        );
      },
    );
  });

  group('removeSavedServer()', () {
    setUp(() {
      when(
        () => mockSecureStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) => Future.value());
    });
    test('should delete the saved server info', () async {
      // act
      await authenticationLocalDataSource.removeSavedServer();

      // assert
      verify(() => mockSecureStorage.delete(key: 'server_url'));
      verify(() => mockSecureStorage.delete(key: 'anon_key'));
      verify(() => mockSecureStorage.delete(key: 'powersync_url'));
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

    test('should save the server info', () async {
      // act
      await authenticationLocalDataSource.saveServerInfo(
        serverInfo: tServerInfo,
      );

      // assert
      verify(
        () =>
            mockSecureStorage.write(key: 'server_url', value: tServerUrlString),
      );
      verify(() => mockSecureStorage.write(key: 'anon_key', value: tAnonKey));
      verify(
        () =>
            mockSecureStorage.write(key: 'powersync_url', value: tPowersyncUrl),
      );
    });
  });

  group('deleteLocalStorage()', () {
    setUp(() {
      when(
        () => mockSecureStorage.deleteAll(),
      ).thenAnswer((_) => Future.value());
    });

    test('should delete all local storage', () async {
      // act
      await authenticationLocalDataSource.deleteLocalStorage();

      // assert
      verify(() => mockSecureStorage.deleteAll());
    });
  });

  group('deleteLocalDBCache()', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      PathProviderPlatform.instance = FakePathProviderPlatform();

      final Directory appDirectory = await getApplicationSupportDirectory();
      final String dbCacheFilePath = join(
        appDirectory.path,
        AppFileConstants.sqliteDbFileName,
      );

      final File dbCacheFile = File(dbCacheFilePath);

      await dbCacheFile.create();
    });

    test('should delete the local db cache', () async {
      // act
      await authenticationLocalDataSource.deleteLocalDBCache();
    });
  });
}
