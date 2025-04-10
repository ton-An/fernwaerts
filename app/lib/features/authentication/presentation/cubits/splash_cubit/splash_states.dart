import 'package:location_history/core/failures/failure.dart';

abstract class SplashState {
  const SplashState();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashAuthenticationRequired extends SplashState {
  const SplashAuthenticationRequired();
}

class SplashAuthenticationComplete extends SplashState {
  const SplashAuthenticationComplete();
}

class SplashFailure extends SplashState {
  const SplashFailure({required this.failure});

  final Failure failure;
}
