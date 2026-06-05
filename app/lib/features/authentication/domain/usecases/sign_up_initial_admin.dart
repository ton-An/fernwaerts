import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/password_mismatch_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';

/// {@template sign_up_initial_admin}
/// Signs up the initial admin user
///
/// After creating the admin account, this use case signs that account in and
/// completes the same sync-server and device-registration steps as [SignIn].
///
/// Parameters:
/// - supabaseInfo: [SupabaseInfo] connection info for the server
/// - username: [String] username of the admin user
/// - email: [String] email of the admin user
/// - password: [String] password of the admin user
/// - repeatedPassword: [String] repeated password of the admin user to confirm
///   it
///
/// Failures:
/// - [PasswordMismatchFailure]
/// - [WeakPasswordFailure]
/// {@macro converted_dio_exceptions}
/// {@macro converted_client_exceptions}
/// {@endtemplate}
class SignUpInitialAdmin {
  /// {@macro sign_up_initial_admin}
  const SignUpInitialAdmin({
    required this.authenticationRepository,
    required this.signIn,
  });

  final AuthenticationRepository authenticationRepository;
  final SignIn signIn;

  /// {@macro sign_up_initial_admin}
  Future<Either<Failure, None>> call({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    if (password != repeatedPassword) {
      return const Left(PasswordMismatchFailure());
    }

    return _signUpInitialAdmin(
      username: username,
      email: email,
      password: password,
      repeatedPassword: repeatedPassword,
      supabaseInfo: supabaseInfo,
    );
  }

  Future<Either<Failure, None>> _signUpInitialAdmin({
    required SupabaseInfo supabaseInfo,
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    final Either<Failure, None> signUpEither = await authenticationRepository
        .signUpInitialAdmin(
          serverUrl: supabaseInfo.url,
          username: username,
          email: email,
          password: password,
        );

    return signUpEither.fold(Left.new, (None none) {
      return _signIn(
        email: email,
        password: password,
        supabaseInfo: supabaseInfo,
      );
    });
  }

  Future<Either<Failure, None>> _signIn({
    required SupabaseInfo supabaseInfo,
    required String email,
    required String password,
  }) {
    return signIn(email: email, password: password, supabaseInfo: supabaseInfo);
  }
}
