import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_cubit.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_states.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String pageName = 'splash';
  static const String route = '/$pageName';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().initAndCheckAuth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticationComplete) {
          context.go(MapPage.route);
        } else {
          if (state is SplashFailure) {
            context.read<InAppNotificationCubit>().sendFailureNotification(
              state.failure,
            );
          }

          context.go(AuthenticationPage.route);
        }
      },
      child: Container(color: Colors.black),
    );
  }
}
