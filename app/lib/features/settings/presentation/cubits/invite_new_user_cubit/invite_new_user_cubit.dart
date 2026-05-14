import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/settings/domain/usecases/invite_new_user.dart';
import 'package:location_history/features/settings/presentation/cubits/invite_new_user_cubit/invite_new_user_state.dart';

/// {@template invite_new_user_cubit}
/// Coordinates invite-new-user actions from the settings UI.
/// {@endtemplate}
class InviteNewUserCubit extends Cubit<InviteNewUserState> {
  /// {@macro invite_new_user_cubit}
  InviteNewUserCubit({required this.inviteNewUserUseCase})
    : super(const InviteNewUserInitial());

  /// Use case that sends user invite requests.
  final InviteNewUser inviteNewUserUseCase;

  /// Starts the invite flow for [email].
  ///
  /// The actual invite request is currently disabled while the invite flow is
  /// being finished.
  void inviteNewUser({required String email}) async {
    // emit(const InviteNewUserLoading());

    // final Either<Failure, None> inviteNewUserEither =
    //     await inviteNewUserUseCase(email: email);

    // inviteNewUserEither.fold(
    //   (failure) => emit(InviteNewUserFailure(failure: failure)),
    //   (_) => emit(const InviteNewUserSuccess()),
    // );
  }
}
