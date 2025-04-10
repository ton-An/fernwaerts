import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_signed_in.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_states.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required this.initSavedServerConnection,
    required this.isSignedInUsecase,
  }) : super(SplashLoading());

  final InitializeSavedServerConnection initSavedServerConnection;
  final IsSignedIn isSignedInUsecase;

  void initAndCheckAuth() async {
    emit(SplashLoading());

    final Either<Failure, None> initServerConnectionEither =
        await initSavedServerConnection();

    initServerConnectionEither.fold(
      (Failure failure) {
        if (failure is NoSavedServerFailure) {
          emit(SplashAuthenticationRequired());
        } else {
          emit(SplashFailure(failure: failure));
        }

        return false;
      },
      (None none) async {
        bool isSignedIn = isSignedInUsecase();

        if (isSignedIn) {
          emit(SplashAuthenticationComplete());
        } else {
          emit(SplashAuthenticationRequired());
        }
      },
    );
  }
}
