import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/has_server_connection_saved.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_signed_in.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/pages/map_page.dart';

/*
  To-Do
    - [ ] Do auth check properly
*/

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
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black);
  }

  Future<void> _init() async {
    final HasServerConnectionSaved hasServerConnectionSaved =
        getIt<HasServerConnectionSaved>();
    final InitializeSavedServerConnection initializeSavedServerConnection =
        getIt<InitializeSavedServerConnection>();
    final IsSignedIn isSignedInUsecase = getIt<IsSignedIn>();

    bool isSignedIn = false;

    final dartz.Either<Failure, bool> hasServerConnectionSavedEither =
        await hasServerConnectionSaved();

    hasServerConnectionSavedEither.fold(
      (Failure failure) {
        context.read<InAppNotificationCubit>().sendFailureNotification(failure);
        context.go(AuthenticationPage.route);
      },
      (bool hasServerConnectionSaved) async {
        if (hasServerConnectionSaved) {
          final dartz.Either<Failure, dartz.None> initServerConnectionEither =
              await initializeSavedServerConnection();

          initServerConnectionEither.fold(
            (Failure failure) {
              context.read<InAppNotificationCubit>().sendFailureNotification(
                failure,
              );
              context.go(AuthenticationPage.route);
            },
            (dartz.None none) async {
              context.go(MapPage.route);
            },
          );
        }
      },
    );
  }
}
