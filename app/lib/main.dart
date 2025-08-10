import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/page_routes/dialog_page.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_cubit.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/authentication/presentation/pages/splash_page.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/widgets/in_app_notification_listener.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:location_history/features/settings/page_routes/settings_slide_transition_page.dart';
import 'package:location_history/features/settings/pages/account_settings_page/account_settings_page.dart';
import 'package:location_history/features/settings/pages/debug_page.dart';
import 'package:location_history/features/settings/pages/main_settings_page/main_settings_page.dart';
import 'package:location_history/features/settings/widgets/settings_page_wrapper/settings_page_wrapper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/*
  General To-Dos:
    - [ ] Standardize animation durations
    - [ ] Delete cached data on sign out and potentially when auth check on splash screen fails
    - [ ] Standardize docs and fix possible errors (using an llm might be a good idea)
    - [ ] Add permissions request screen
    - [ ] Add log settings page
    - [ ] Add final keyword to function arguments
*/

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      initGetIt();

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      await getIt.isReady<PackageInfo>();

      Bloc.observer = TalkerBlocObserver(
        talker: getIt<Talker>(),
        settings: const TalkerBlocLoggerSettings(printChanges: true),
      );

      runApp(const MainApp());
    },
    (exception, stackTrace) {
      getIt<Talker>().handle(exception, stackTrace, 'Uncaught Exception');
      Error.throwWithStackTrace(exception, stackTrace);
    },
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();

    _initRouter();
  }

  @override
  Widget build(BuildContext context) {
    return WebfabrikTheme(
      data: WebfabrikThemeData(
        colors: WebfabrikColorThemeData(
          primary: const Color.fromARGB(255, 83, 196, 108),
          primaryTranslucent: const Color.fromARGB(
            255,
            83,
            196,
            108,
          ).withValues(alpha: .3),
        ),
        misc: WebfabrikMiscThemeData(
          blurFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        ),
      ),
      child: MultiBlocProvider(
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
      ),
    );
  }

  void _initRouter() {
    router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: SplashPage.route,
      routes: <RouteBase>[
        ShellRoute(
          builder:
              (context, state, child) =>
                  InAppNotificationListener(child: child),
          routes: [
            GoRoute(
              path: '/',

              /// This base route is necessary for the edges of the modal to be blurred
              /// when an [InAppNotification] is shown.
              pageBuilder:
                  (context, state) => const NoTransitionPage(
                    child: ColoredBox(color: Colors.white),
                  ),
              routes: [
                GoRoute(
                  path: SplashPage.pageName,
                  builder:
                      (context, state) => BlocProvider(
                        create: (context) => getIt<SplashCubit>(),
                        child: const SplashPage(),
                      ),
                ),
                GoRoute(
                  path: DebugPage.pageName,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(child: DebugPage());
                  },
                ),
                GoRoute(
                  path: AuthenticationPage.pageName,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => getIt<AuthenticationCubit>(),
                          ),
                        ],
                        child: const AuthenticationPage(),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: MapPage.pageName,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create:
                                (context) => getIt<CalendarExpansionCubit>(),
                          ),
                          BlocProvider(
                            create:
                                (context) =>
                                    getIt<CalendarSelectionTypeCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => getIt<MonthlyCalendarCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => getIt<YearlyCalendarCubit>(),
                          ),
                          BlocProvider(
                            create:
                                (context) => getIt<DecenniallyCalendarCubit>(),
                          ),
                          BlocProvider(
                            create:
                                (context) =>
                                    getIt<CalendarDateSelectionCubit>(),
                          ),
                          BlocProvider(create: (context) => getIt<MapCubit>()),
                        ],
                        child: const MapPage(),
                      ),
                    );
                  },
                  routes: [
                    ShellRoute(
                      pageBuilder: (context, state, child) {
                        return DialogPage(
                          child: SettingsPageWrapper(
                            pagePath: state.fullPath,
                            child: child,
                          ),
                        );
                      },

                      routes: [
                        GoRoute(
                          path: MainSettingsPage.pageName,
                          pageBuilder: (context, state) {
                            return const SettingsSlideTransitionPage(
                              child: MainSettingsPage(),
                            );
                          },
                          routes: [
                            GoRoute(
                              path: AccountSettingsPage.pageName,
                              pageBuilder:
                                  (context, state) =>
                                      const SettingsSlideTransitionPage(
                                        child: AccountSettingsPage(),
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );

    router.routerDelegate.addListener(() {
      final String? routePath = router.routerDelegate.state.fullPath;

      if (routePath != null) getIt<Talker>().info('Opened route: $routePath');
    });
  }
}
