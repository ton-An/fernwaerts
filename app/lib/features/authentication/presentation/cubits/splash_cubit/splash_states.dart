import 'package:location_history/core/failures/failure.dart';

abstract class SplashState {
  const SplashState();
}

/// {@template splash_loading}
/// A class that represents splash loading.
/// {@endtemplate}
class SplashLoading extends SplashState {
/// {@macro splash_loading}
  const SplashLoading();
}

/// {@template splash_authentication_required}
/// A class that represents splash authentication required.
/// {@endtemplate}
class SplashAuthenticationRequired extends SplashState {
/// {@macro splash_authentication_required}
  const SplashAuthenticationRequired();
}

/// {@template splash_authentication_complete}
/// A class that represents splash authentication complete.
/// {@endtemplate}
class SplashAuthenticationComplete extends SplashState {
/// {@macro splash_authentication_complete}
  const SplashAuthenticationComplete();
}

/// {@template splash_failure}
/// A class that represents splash failure.
/// {@endtemplate}
class SplashFailure extends SplashState {
/// {@macro splash_failure}
  const SplashFailure({required this.failure});

  final Failure failure;
}
