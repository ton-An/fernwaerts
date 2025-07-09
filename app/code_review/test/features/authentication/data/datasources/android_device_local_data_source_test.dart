import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/features/authentication/data/datasources/android_device_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late AndroidDeviceLocalDataSource androidDeviceLocalDataSourceImpl;
  late MockDeviceInfoPlugin mockDeviceInfoPlugin;

  setUp(() {
    mockDeviceInfoPlugin = MockDeviceInfoPlugin();
    androidDeviceLocalDataSourceImpl = AndroidDeviceLocalDataSourceImpl(
      deviceInfoPlugin: mockDeviceInfoPlugin,
    );
  });

  group('getRawDeviceInfo()', () {
    setUp(() {
      when(
        () => mockDeviceInfoPlugin.androidInfo,
      ).thenAnswer((_) async => tAndroidDeviceInfo);
    });

    test(
      'should get the device information from the device info plugin and return a device',
      () async {
        // act
        final result =
            await androidDeviceLocalDataSourceImpl.getRawDeviceInfo();

        // assert
        expect(result, tAndroidRawDevice);
        verify(() => mockDeviceInfoPlugin.androidInfo);
      },
    );
  });
}
