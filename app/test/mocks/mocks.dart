import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/data/datasources/platform_wrapper.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/android_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/base_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/device_remote_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/ios_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_app.dart';
import 'package:location_history/features/authentication/domain/usecases/save_device_info_to_db.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';
import 'package:location_history/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -- Third Party -- //
class MockDio extends Mock implements Dio {}

class MockSupabase extends Mock implements Supabase {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder<T> extends Mock
    implements PostgrestFilterBuilder<T> {}

class MockPostgrestTransformBuilder<T> extends Mock
    implements PostgrestTransformBuilder<T> {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockFlutterActivityRecognition extends Mock
    implements FlutterActivityRecognition {}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class MockPackageInfo extends Mock implements PackageInfo {}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationSupportPath() async {
    return './test';
  }
}

// -- Core -- //
class MockServerRemoteHandler extends Mock implements ServerRemoteHandler {}

class MockRepositoryFailureHandler extends Mock
    implements RepositoryFailureHandler {}

class MockSupabaseHandler extends Mock implements SupabaseHandler {}

class MockPlatformWrapper extends Mock implements PlatformWrapper {}

// -- Authentication
class MockDeviceRemoteDataSource extends Mock
    implements DeviceRemoteDataSource {}

class MockIOSDeviceLocalDataSource extends Mock
    implements IOSDeviceLocalDataSource {}

class MockAndroidDeviceLocalDataSource extends Mock
    implements AndroidDeviceLocalDataSource {}

class MockBaseDeviceLocalDataSource extends Mock
    implements BaseDeviceLocalDataSource {}

class MockAuthLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

class MockPermissionsLocalDataSource extends Mock
    implements PermissionsLocalDataSource {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockInitializeApp extends Mock implements InitializeApp {}

class MockSignIn extends Mock implements SignIn {}

class MockSaveDeviceInfo extends Mock implements SaveDeviceInfo {}

// -- Location Tracking
class MockLocationTrackingRepository extends Mock
    implements LocationTrackingRepository {}

class MockLocationDataRepository extends Mock
    implements LocationDataRepository {}

class MockLocationDataRemoteDataSource extends Mock
    implements LocationDataRemoteDataSource {}

// -- Settings
class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}
