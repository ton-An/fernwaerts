import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/base_device_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:location_history/features/authentication/data/repository_implementations/authentication_repository_impl.dart';
import 'package:location_history/features/authentication/data/repository_implementations/device_repository_impl.dart';
import 'package:location_history/features/authentication/data/repository_implementations/permissions_repository_impl.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/has_server_connection_saved.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_server_set_up.dart';
import 'package:location_history/features/authentication/domain/usecases/is_signed_in.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/location_tracking/data/datasources/ios_location_tracking_local_data_source.dart';
import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/data/repository_implementations/location_data_repository_impl.dart';
import 'package:location_history/features/location_tracking/data/repository_implementations/location_tracking_repository_impl.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_locations_by_date.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';

import '../features/location_tracking/domain/usecases/init_background_location_tracking.dart';

final GetIt getIt = GetIt.instance;

void initGetIt() {
  registerThirdPartyDependencies();
  registerCoreDependencies();
  registerInAppNotificationDependencies();
  registerAuthenticationDependencies();
  registerCalendarDependencies();
  registerLocationTrackingDependencies();
}

void registerThirdPartyDependencies() {
  // -- Data -- //
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => FlutterActivityRecognition.instance);
}

void registerCoreDependencies() {
  // -- Data -- //
  getIt.registerLazySingleton<RepositoryFailureHandler>(
    () => const RepositoryFailureHandlerImpl(),
  );
  getIt.registerLazySingleton<ServerRemoteHandler>(
    () => ServerRemoteHandlerImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<SupabaseHandler>(() => SupabaseHandler());
  getIt.registerSingletonAsync<
    OfflineFirstWithSupabaseRepository<OfflineFirstWithSupabaseModel>
  >(() async => await getIt<SupabaseHandler>().supabaseOfflineFirst);
}

void registerInAppNotificationDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => InAppNotificationCubit());
}

void registerAuthenticationDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(
    () => AuthenticationCubit(
      initializeServerConnection: getIt(),
      isServerSetUp: getIt(),
      signUpInitialAdmin: getIt(),
      signInUsecase: getIt(),
      requestNecessaryPermissions: getIt(),
    ),
  );
  getIt.registerFactory(
    () => SplashCubit(
      initSavedServerConnection: getIt(),
      isSignedInUsecase: getIt(),
      requestNecessaryPermissions: getIt(),
    ),
  );

  // -- Domain -- //
  getIt.registerLazySingleton(
    () => InitializeNewServerConnection(authenticationRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => IsServerSetUp(authenticationRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () =>
        SignUpInitialAdmin(authenticationRepository: getIt(), signIn: getIt()),
  );
  getIt.registerLazySingleton(() => SignIn(authenticationRepository: getIt()));
  getIt.registerLazySingleton(() => SignOut(authenticationRepository: getIt()));
  getIt.registerLazySingleton(
    () => HasServerConnectionSaved(authenticationRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => InitializeSavedServerConnection(authenticationRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => IsSignedIn(authenticationRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => RequestNecessaryPermissions(permissionsRepository: getIt()),
  );

  // -- Data -- //
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      authRemoteDataSource: getIt(),
      authLocalDataSource: getIt(),
      repositoryFailureHandler: getIt(),
    ),
  );
  getIt.registerLazySingleton<PermissionsRepository>(
    () => PermissionsRepositoryImpl(permissionsLocalDataSource: getIt()),
  );
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(baseDeviceLocalDataSource: getIt()),
  );
  getIt.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt()),
  );
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serverRemoteHandler: getIt(),
      supabaseHandler: getIt(),
    ),
  );
  getIt.registerLazySingleton<PermissionsLocalDataSource>(
    () => PermissionsLocalDataSourceImpl(flutterActivityRecognition: getIt()),
  );
  getIt.registerLazySingleton<BaseDeviceLocalDataSource>(
    () => BaseDeviceLocalDataSourceImpl(secureStorage: getIt()),
  );
}

void registerCalendarDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => CalendarExpansionCubit());
  getIt.registerFactory(() => CalendarSelectionTypeCubit());
  getIt.registerFactory(() => MonthlyCalendarCubit());
  getIt.registerFactory(() => YearlyCalendarCubit());
  getIt.registerFactory(() => DecenniallyCalendarCubit());
  getIt.registerFactory(() => CalendarDateSelectionCubit());
}

void registerLocationTrackingDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => MapCubit(getLocationData: getIt()));

  // -- Domain -- //
  getIt.registerLazySingleton(
    () => InitBackgroundLocationTracking(
      initializeSavedServerConnection: getIt(),
      authenticationRepository: getIt(),
      deviceRepository: getIt(),
      locationTrackingRepository: getIt(),
      locationDataRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetLocationsByDate(
      authenticationRepository: getIt(),
      locationDataRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton<LocationTrackingRepository>(
    () => LocationTrackingRepositoryImpl(
      iosLocationTrackingLocalDataSource: getIt(),
    ),
  );

  // -- Data -- //
  getIt.registerLazySingleton<LocationDataRepository>(
    () => LocationDataRepositoryImpl(locationRemoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<IOSLocationTrackingLocalDataSource>(
    () => IOSLocationTrackingLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<LocationDataRemoteDataSource>(
    () => LocationDataRemoteDataSourceImpl(supabaseOfflineFirst: getIt()),
  );
}
