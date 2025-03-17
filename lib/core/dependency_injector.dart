import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:location_history/core/helpers/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/data/repository_implementations/authentication_repository_impl.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/check_server_reachability.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';

final GetIt getIt = GetIt.instance;

void initGetIt() {
  registerThirdPartyDependencies();
  registerCoreDependencies();
  registerInAppNotificationDependencies();
  registerAuthenticationDependencies();
  registerCalendarDependencies();
}

void registerThirdPartyDependencies() {
  // -- Data -- //
  getIt.registerLazySingleton(() => Dio());
}

void registerCoreDependencies() {
  // -- Data -- //
  getIt.registerLazySingleton(() => RepositoryFailureHandler());
}

void registerInAppNotificationDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => InAppNotificationCubit());
}

void registerAuthenticationDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(
    () => AuthenticationCubit(checkServerReachability: getIt()),
  );

  // -- Domain -- //
  getIt.registerLazySingleton(
    () => CheckServerReachability(authenticationRepository: getIt()),
  );

  // -- Data -- //
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      authRemoteDataSource: getIt(),
      repositoryFailureHandler: getIt(),
    ),
  );
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
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
