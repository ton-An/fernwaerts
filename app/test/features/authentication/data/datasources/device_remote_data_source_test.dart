import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/authentication/data/datasources/device_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late DeviceRemoteDataSourceImpl deviceRemoteDataSourceImpl;
  late MockSupabaseHandler mockSupabaseHandler;

  late DriftAppDatabase mockDriftDatabase;

  setUp(() async {
    mockSupabaseHandler = MockSupabaseHandler();
    deviceRemoteDataSourceImpl = DeviceRemoteDataSourceImpl(
      supabaseHandler: mockSupabaseHandler,
    );

    mockDriftDatabase = DriftAppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    when(
      () => mockSupabaseHandler.driftDatabase,
    ).thenAnswer((_) async => mockDriftDatabase);
  });

  tearDown(() async {
    await mockDriftDatabase.close();
  });

  group('saveDeviceToDB', () {
    test('should save device to DB', () async {
      // act
      await deviceRemoteDataSourceImpl.saveDeviceInfoToDB(device: tDevice);

      // assert
      final Device deviceInDB =
          (await mockDriftDatabase
              .select(mockDriftDatabase.devices)
              .getSingle());
      expect(deviceInDB, tDevice);
    });
  });
}
