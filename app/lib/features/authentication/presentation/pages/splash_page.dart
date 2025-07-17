import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_states.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:location_history/features/settings/pages/debug_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template splash_page}
/// A page displayed during app initialization.
///
/// This page is responsible for triggering the initial app state check
/// via the [SplashCubit]. Based on the authentication status, it navigates
/// either to the [MapPage] (if authenticated) or the [AuthenticationPage]
/// (if not authenticated or an error occurs).
///
/// It also handles displaying any failures encountered during the initialization
/// process using the [InAppNotificationCubit].
/// {@endtemplate}
class SplashPage extends StatefulWidget {
  /// {@macro splash_page}
  const SplashPage({super.key});

  static const String pageName = 'splash';
  static const String route = '/$pageName';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// {@template splash_page_state}
/// {@endtemplate}
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().determineInitialAppState();
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashFailure) {
          context.read<InAppNotificationCubit>().sendFailureNotification(
            state.failure,
          );
        }

        if (state is SplashAuthenticationComplete) {
          context.go(MapPage.route);
        }

        if (state is SplashAuthenticationRequired) {
          context.go(AuthenticationPage.route);
        }
      },
      child: Container(
        color: Colors.black,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTap: () {
            context.push(DebugPage.route);
          },
          child: Container(
            padding: EdgeInsets.all(theme.spacing.large),
            alignment: Alignment.center,
            child: const LoadingIndicator(),
          ),
        ),
      ),
    );
  }
}
