import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/features/authentication/data/datasources/ios_device_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late IosDeviceLocalDataSourceImpl iosDeviceLocalDataSourceImpl;
  late MockDeviceInfoPlugin mockDeviceInfoPlugin;

  setUp(() {
    mockDeviceInfoPlugin = MockDeviceInfoPlugin();
    iosDeviceLocalDataSourceImpl = IosDeviceLocalDataSourceImpl(
      deviceInfoPlugin: mockDeviceInfoPlugin,
    );
  });

  group('getRawDeviceInfo', () {
    setUp(() {
      when(
        () => mockDeviceInfoPlugin.iosInfo,
      ).thenAnswer((_) async => tIOSDeviceInfo);
    });

    test(
      'should get the device information from the device info plugin and return a device',
      () async {
        // act
        final result = await iosDeviceLocalDataSourceImpl.getRawDeviceInfo();

        // assert
        expect(result, tRawDevice);
        verify(() => mockDeviceInfoPlugin.iosInfo);
      },
    );
  });
}
