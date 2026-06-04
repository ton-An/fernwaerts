/// Static values for the auth E2E suite.
class E2EConfig {
  E2EConfig._();

  /// Backend URLs are passed by `app/tool/run_e2e.sh`.
  static const String serverUrl = String.fromEnvironment('E2E_SERVER_URL');
  static const String mailpitUrl = String.fromEnvironment('E2E_MAILPIT_URL');

  static const String adminUsername = 'e2e-admin';
  static const String adminEmail = 'admin@fernwaerts.test';
  static const String adminUpdatedEmail = 'admin-updated@fernwaerts.test';
  static const String adminPassword = 'E2ePassword!1';
  static const String adminNewPassword = 'E2ePassword!2';

  static const String invitedUsername = 'e2e-invitee';
  static const String invitedEmail = 'invitee@fernwaerts.test';
  static const String invitedPassword = 'E2ePassword!1';

  /// Generous enough for Docker-backed auth requests without hiding hangs.
  static const Duration networkTimeout = Duration(seconds: 20);
  static const Duration mailPollInterval = Duration(milliseconds: 300);
  static const Duration mailWaitTimeout = Duration(seconds: 20);
}
