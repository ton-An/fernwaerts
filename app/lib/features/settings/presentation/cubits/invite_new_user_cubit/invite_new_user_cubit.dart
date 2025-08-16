import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/settings/domain/usecases/invite_new_user.dart';
import 'package:location_history/features/settings/presentation/cubits/invite_new_user_cubit/invite_new_user_states.dart';

class InviteNewUserCubit extends Cubit<InviteNewUserState> {
  InviteNewUserCubit({required this.inviteNewUserUseCase})
    : super(const InviteNewUserInitial());

  final InviteNewUser inviteNewUserUseCase;

  void inviteNewUser({required String email}) async {
    emit(const InviteNewUserLoading());

    final Either<Failure, None> inviteNewUserEither =
        await inviteNewUserUseCase(email: email);

    inviteNewUserEither.fold(
      (failure) => emit(InviteNewUserFailure(failure: failure)),
      (_) => emit(const InviteNewUserSuccess()),
    );
  }
}
