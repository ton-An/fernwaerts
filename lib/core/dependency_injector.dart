import 'package:get_it/get_it.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';

final GetIt getIt = GetIt.instance;

void initGetIt() {
  registerCalendarDependencies();
}

void registerCalendarDependencies() {
  // -- Presentation -- //
  getIt.registerFactory(() => CalendarExpansionCubit());
  getIt.registerFactory(() => CalendarSelectionTypeCubit());
  getIt.registerFactory(() => MonthlyCalendarCubit());
  getIt.registerFactory(() => CalendarDateSelectionCubit());
}
