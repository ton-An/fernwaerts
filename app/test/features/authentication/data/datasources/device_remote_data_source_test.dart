import 'package:brick_supabase/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/brick/brick.g.dart';
import 'package:location_history/features/authentication/data/datasources/device_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mock_supabase_offline_first_repository.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late DeviceRemoteDataSourceImpl deviceRemoteDataSourceImpl;
  late MockSupabaseHandler mockSupabaseHandler;
  late SupabaseMockServer mockSupabaseServer;
  late MockSupabaseOfflineFirstRepository mockSupabaseOfflineFirstRepository;

  setUp(() async {
    mockSupabaseServer = SupabaseMockServer(
      modelDictionary: supabaseModelDictionary,
    );
    await mockSupabaseServer.setUp();
    mockSupabaseOfflineFirstRepository =
        MockSupabaseOfflineFirstRepository.configure(
          mockSupabaseServer: mockSupabaseServer,
        );
    await mockSupabaseOfflineFirstRepository.initialize();
    mockSupabaseHandler = MockSupabaseHandler();
    deviceRemoteDataSourceImpl = DeviceRemoteDataSourceImpl(
      supabaseHandler: mockSupabaseHandler,
    );

    when(
      () => mockSupabaseHandler.supabaseOfflineFirst,
    ).thenAnswer((_) async => mockSupabaseOfflineFirstRepository);
  });

  tearDown(() async {
    await mockSupabaseServer.tearDown();
    await mockSupabaseOfflineFirstRepository.reset();
  });

  group('saveDeviceToDB', () {
    setUp(() async {
      mockSupabaseServer.handle({});
    });
    test('should save device to DB', () async {
      // act
      await deviceRemoteDataSourceImpl.saveDeviceInfoToDB(device: tDevice);

      // assert
      final Device deviceInDB =
          (await mockSupabaseOfflineFirstRepository.get<Device>()).first;
      expect(deviceInDB, tDevice);
    });
  });
}
