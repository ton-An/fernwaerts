import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initGetIt();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
      ],
    );
  }

  final GoRouter router = GoRouter(
    initialLocation: MapPage.route,
    routes: <RouteBase>[
      GoRoute(
        path: MapPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(providers: [
            BlocProvider(create: (context) => getIt<CalendarExpansionCubit>()),
            BlocProvider(
                create: (context) => getIt<CalendarSelectionTypeCubit>()),
            BlocProvider(create: (context) => getIt<MonthlyCalendarCubit>()),
            BlocProvider(
                create: (context) => getIt<CalendarDateSelectionCubit>()),
          ], child: MapPage());
        },
      ),
    ],
  );
}
