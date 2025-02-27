import 'package:get_it/get_it.dart';
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
  registerInAppNotificationDependencies();
  registerAuthenticationDependencies();
  registerCalendarDependencies();
}

void registerInAppNotificationDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => InAppNotificationCubit());
}

void registerAuthenticationDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => AuthenticationCubit());
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
