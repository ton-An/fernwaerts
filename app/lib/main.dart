import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/widgets/in_app_notification_listener.dart';
import 'package:location_history/features/map/presentation/pages/map_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initGetIt();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<InAppNotificationCubit>()),
      ],
      child: CupertinoApp.router(
        onGenerateTitle:
            (BuildContext context) => AppLocalizations.of(context)!.appName,
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
      ),
    );
  }

  final GoRouter router = GoRouter(
    initialLocation: AuthenticationPage.route,
    routes: <RouteBase>[
      ShellRoute(
        builder:
            (context, state, child) => InAppNotificationListener(child: child),
        routes: [
          GoRoute(
            path: '/',

            /// This base route is necessary for the edges of the modal to be blurred
            /// when an [InAppNotification] is shown.
            pageBuilder:
                (context, state) =>
                    const CupertinoPage(child: ColoredBox(color: Colors.black)),
            routes: [
              GoRoute(
                path: AuthenticationPage.pageName,
                builder: (BuildContext context, GoRouterState state) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => getIt<AuthenticationCubit>(),
                      ),
                    ],
                    child: const AuthenticationPage(),
                  );
                },
              ),
              GoRoute(
                path: MapPage.pageName,
                builder: (BuildContext context, GoRouterState state) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => getIt<CalendarExpansionCubit>(),
                      ),
                      BlocProvider(
                        create:
                            (context) => getIt<CalendarSelectionTypeCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<MonthlyCalendarCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<YearlyCalendarCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<DecenniallyCalendarCubit>(),
                      ),
                      BlocProvider(
                        create:
                            (context) => getIt<CalendarDateSelectionCubit>(),
                      ),
                    ],
                    child: MapPage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
