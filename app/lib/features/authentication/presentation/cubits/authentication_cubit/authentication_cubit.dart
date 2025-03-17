import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/check_server_reachability.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.checkServerReachability})
    : super(AuthenticationInitial());

  final CheckServerReachability checkServerReachability;

  void toServerDetails() {
    emit(EnterServerDetails());
  }

  void toLogInInfo(String serverUrl) async {
    final Either<Failure, None> reachabilityCheckEither =
        await checkServerReachability(serverUrl: Uri.parse(serverUrl));

    reachabilityCheckEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) {
        emit(EnterAdminSignUpInfo());
      },
    );
  }

  void signUpAdmin(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) {
    emit(AdminSignUpSuccessful());
  }

  void logIn(String username, String password) {
    emit(LogInSuccessful());
  }
}
