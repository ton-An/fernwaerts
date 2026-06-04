/// Static configuration for the e2e suite.
///
/// Values can be overridden at run time with `--dart-define=KEY=value`. The
/// defaults assume the Docker compose stack from `supabase/deploy/` is running
/// on the host machine and is reachable on `127.0.0.1` from the device under
/// test (true for the iOS Simulator, macOS, and Linux desktop targets).
class E2EConfig {
  E2EConfig._();

  /// Public URL the app uses to reach the Supabase/PowerSync backend.
  static const String serverUrl = String.fromEnvironment(
    'E2E_SERVER_URL',
    defaultValue: 'http://192.168.0.47:8000',
  );

  /// Mailpit HTTP API base URL. Tests poll this to retrieve invite links and
  /// reauthentication OTPs that GoTrue emails out.
  static const String mailpitUrl = String.fromEnvironment(
    'E2E_MAILPIT_URL',
    defaultValue: 'http://192.168.0.47:8025',
  );

  static const String adminUsername = 'e2e-admin';
  static const String adminEmail = 'admin@fernwaerts.test';
  static const String adminUpdatedEmail = 'admin-updated@fernwaerts.test';
  static const String adminPassword = 'E2ePassword!1';
  static const String adminNewPassword = 'E2ePassword!2';

  static const String invitedUsername = 'e2e-invitee';
  static const String invitedEmail = 'invitee@fernwaerts.test';
  static const String invitedPassword = 'E2ePassword!1';

  /// Upper bound for the longest backend round-trip in any single test step.
  static const Duration networkTimeout = Duration(seconds: 20);

  /// Polling interval used while waiting for the Mailpit API to surface a
  /// freshly sent message.
  static const Duration mailPollInterval = Duration(milliseconds: 300);

  /// Upper bound for waiting on a single email to arrive at Mailpit.
  static const Duration mailWaitTimeout = Duration(seconds: 20);
}
