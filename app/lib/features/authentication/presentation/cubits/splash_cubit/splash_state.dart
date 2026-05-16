import 'package:location_history/core/failures/failure.dart';

/// {@template splash_state}
/// Base state for app startup and saved-session initialization.
/// {@endtemplate}
abstract class SplashState {
  /// {@macro splash_state}
  const SplashState();
}

/// {@template splash_loading}
/// Indicates that saved server and session initialization is running.
/// {@endtemplate}
class SplashLoading extends SplashState {
  /// {@macro splash_loading}
  const SplashLoading();
}

/// {@template splash_authentication_required}
/// Indicates that the user must complete the authentication flow.
/// {@endtemplate}
class SplashAuthenticationRequired extends SplashState {
  /// {@macro splash_authentication_required}
  const SplashAuthenticationRequired();
}

/// {@template splash_authentication_complete}
/// Indicates that the saved server and user session are ready for app use.
/// {@endtemplate}
class SplashAuthenticationComplete extends SplashState {
  /// {@macro splash_authentication_complete}
  const SplashAuthenticationComplete();
}

/// {@template splash_failure}
/// Carries a startup [failure] that should be displayed without changing route.
/// {@endtemplate}
class SplashFailure extends SplashState {
  /// {@macro splash_failure}
  const SplashFailure({required this.failure});

  /// Failure displayed to the user by the splash page listener.
  final Failure failure;
}
