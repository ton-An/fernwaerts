import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/authentication/presentation/pages/invite_page/invite_page.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:location_history/features/settings/presentation/pages/account_settings_page/account_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/invite_new_user_settings_page/invite_new_user_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/main_settings_page/main_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/password_change_settings_page/password_change_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/user_management_settings_page/user_management_settings_page.dart';
import 'package:location_history/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'e2e_support/e2e_config.dart';
import 'e2e_support/e2e_stubs.dart';
import 'e2e_support/mailpit_client.dart';
import 'e2e_support/test_actions.dart';

/// End-to-end UI tests against a real self-host Docker backend.
///
/// The tests share a single Flutter session and one signed-in state machine so
/// they only pay the cost of bootstrapping Supabase, PowerSync, and secure
/// storage once. Tests run in the declared order; each flow leaves the app in
/// a known state for the next one. See `app/tool/run_e2e.sh` for the
/// orchestration script that boots Docker, prepares mail capture, runs this
/// file, and tears everything down.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late final MailpitClient mail;

  setUpAll(() async {
    initGetIt();
    registerE2EStubs();
    await getIt.isReady<PackageInfo>();
    // The simulator keychain persists across runs; a stale server URL or
    // session token from a previous run would route the app past the splash
    // before the first test step gets a chance to look.
    await const FlutterSecureStorage().deleteAll();
    mail = MailpitClient();
    await mail.deleteAll();

    // Sanity-probe the backend from inside the simulator network. If this
    // fails the whole test would otherwise time out on a "Connection Failure"
    // notification with no diagnostic.
    final client = HttpClient();
    try {
      final probe = await client
          .getUrl(Uri.parse('${E2EConfig.serverUrl}/functions/v1/get_anon_key'))
          .then((req) => req.close())
          .timeout(const Duration(seconds: 5));
      await probe.drain<void>();
      // ignore: avoid_print
      print('[e2e] backend probe (HttpClient): HTTP ${probe.statusCode}');
    } catch (e) {
      // ignore: avoid_print
      print('[e2e] backend probe (HttpClient) FAILED: $e');
    } finally {
      client.close(force: true);
    }

    // Attach a one-shot interceptor to the DI Dio so the FIRST request the
    // app makes (the cubit's server-connection check) is logged with the
    // actual URL and error.
    getIt<Dio>().interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // ignore: avoid_print
          print('[e2e] dio REQ ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('[e2e] dio RES ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (err, handler) {
          // ignore: avoid_print
          print('[e2e] dio ERR type=${err.type} uri=${err.requestOptions.uri} '
              'msg=${err.message} err=${err.error}');
          handler.next(err);
        },
      ),
    );
  });

  tearDownAll(() => mail.close());

  testWidgets(
    'auth surface — admin signup, sign in, invite, accept, '
    'password reset, email change',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      // The splash routes itself; the first thing we can drive is whatever
      // page it lands on. Without a saved server URL that's
      // [AuthenticationPage].
      await pumpUntil(tester, find.byType(AuthenticationPage));

      await _initialAdminSignUp(tester);
      await _signOut(tester);

      await _signInAsAdmin(tester);
      final inviteUri = await _sendInvitation(tester, mail);
      await _returnToMap(tester);
      await _signOut(tester);

      await _acceptInvite(tester, inviteUri);
      await _signOut(tester);

      await _signInAsAdmin(tester);
      await _resetPasswordWithOtp(tester, mail);
      await _returnToMap(tester);
      await _changeEmail(tester, mail);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

// ---------------------------------------------------------------------------
// Flow steps
// ---------------------------------------------------------------------------

/// First-run admin enrollment: the server has no admin yet, so submitting the
/// server URL routes to the admin signup form.
Future<void> _initialAdminSignUp(WidgetTester tester) async {
  await pumpUntil(tester, find.byType(AuthenticationPage));

  final l10n = _l10n(tester);
  await tapSemantic(tester, l10n.semanticGetStartedButton);

  await enterTextInto(tester, l10n.semanticServerUrlField, E2EConfig.serverUrl);
  await tapSemantic(tester, l10n.semanticServerContinueButton);

  await pumpUntil(tester, findBySemanticLabel(l10n.semanticAdminUsernameField));
  await enterTextInto(
    tester,
    l10n.semanticAdminUsernameField,
    E2EConfig.adminUsername,
  );
  await enterTextInto(
    tester,
    l10n.semanticAdminEmailField,
    E2EConfig.adminEmail,
  );
  await enterTextInto(
    tester,
    l10n.semanticAdminPasswordField,
    E2EConfig.adminPassword,
  );
  await enterTextInto(
    tester,
    l10n.semanticAdminConfirmPasswordField,
    E2EConfig.adminPassword,
  );
  await tapSemantic(tester, l10n.semanticCreateAdminButton);

  await pumpUntil(tester, find.byType(MapPage));
}

/// Subsequent sign-in: the admin already exists, so the server URL form leads
/// straight into the sign-in form.
Future<void> _signInAsAdmin(WidgetTester tester) async {
  await pumpUntil(tester, find.byType(AuthenticationPage));

  final l10n = _l10n(tester);
  await tapSemantic(tester, l10n.semanticGetStartedButton);

  await enterTextInto(tester, l10n.semanticServerUrlField, E2EConfig.serverUrl);
  await tapSemantic(tester, l10n.semanticServerContinueButton);

  await pumpUntil(tester, findBySemanticLabel(l10n.semanticSignInEmailField));
  await enterTextInto(
    tester,
    l10n.semanticSignInEmailField,
    E2EConfig.adminEmail,
  );
  await enterTextInto(
    tester,
    l10n.semanticSignInPasswordField,
    E2EConfig.adminPassword,
  );
  await tapSemantic(tester, l10n.semanticSignInButton);

  await pumpUntil(tester, find.byType(MapPage));
}

/// Admin-only invite: opens settings → user management → invite form, submits
/// the invitee email, and returns the URL parsed out of the Mailpit message
/// for the next test step to consume.
Future<Uri> _sendInvitation(WidgetTester tester, MailpitClient mail) async {
  final l10n = _l10n(tester);

  await mail.deleteAll();

  dismissActiveNotification();
  await tester.pump(const Duration(milliseconds: 300));
  await tapSemantic(tester, l10n.semanticMapSettingsButton);
  await pumpUntil(tester, find.byType(MainSettingsPage));

  await tapSemantic(tester, l10n.semanticUserManagementLink);
  await pumpUntil(tester, find.byType(UserManagementSettingsPage));

  await tapSemantic(tester, l10n.semanticInviteNewUserLink);
  await pumpUntil(tester, find.byType(InviteNewUserSettingsPage));

  await enterTextInto(
    tester,
    l10n.semanticInviteNewUserEmailField,
    E2EConfig.invitedEmail,
  );
  await tapSemantic(tester, l10n.semanticInviteNewUserButton);

  final message = await mail.waitForLatestTo(E2EConfig.invitedEmail);
  return message.confirmationUrl;
}

/// Closes the settings overlay and returns to the map page directly via
/// GoRouter instead of tapping the back button on every intermediate page.
Future<void> _returnToMap(WidgetTester tester) async {
  goTo(tester, MapPage.route);
  await pumpUntilGone(tester, find.byType(MainSettingsPage));
}

/// Signs the current user out from the settings sign-out confirmation dialog.
Future<void> _signOut(WidgetTester tester) async {
  await pumpUntil(tester, find.byType(MapPage));
  final l10n = _l10n(tester);

  dismissActiveNotification();
  await tester.pump(const Duration(milliseconds: 300));
  await tapSemantic(tester, l10n.semanticMapSettingsButton);
  await pumpUntil(tester, find.byType(MainSettingsPage));

  await tapSemantic(tester, l10n.semanticSignOutButton);
  await tapSemantic(tester, l10n.semanticConfirmDialogActionButton);

  await pumpUntil(tester, find.byType(AuthenticationPage));
  // The SignOut use case is fire-and-forget — give its PowerSync teardown and
  // secure-storage clear a moment to finish so the next flow starts clean.
  await tester.pump(const Duration(milliseconds: 800));
}

/// Follows the invite link the way Supabase's email redirect would: hits the
/// `/auth/v1/verify` URL, captures the access/refresh tokens from the redirect
/// Location, then injects them into the app via GoRouter.
Future<void> _acceptInvite(WidgetTester tester, Uri inviteUri) async {
  final callback = await _resolveInviteRedirect(inviteUri);
  final fragmentParams = Uri.splitQueryString(callback.fragment);
  final refreshToken = fragmentParams['refresh_token'];
  final serverUrlFromCallback = callback.queryParameters['serverUrl'];
  expect(
    refreshToken,
    isNotNull,
    reason: 'No refresh_token in invite callback: $callback',
  );
  expect(
    serverUrlFromCallback,
    isNotNull,
    reason: 'No serverUrl in invite callback: $callback',
  );

  final deepLink = Uri(
    path: InvitePage.route,
    queryParameters: {
      'serverUrl': serverUrlFromCallback,
      'refreshToken': refreshToken,
    },
  ).toString();
  goTo(tester, deepLink);

  await pumpUntil(tester, find.byType(InvitePage));

  final l10n = _l10n(tester);
  await pumpUntil(
    tester,
    findBySemanticLabel(l10n.semanticInviteUsernameField),
  );
  await enterTextInto(
    tester,
    l10n.semanticInviteUsernameField,
    E2EConfig.invitedUsername,
  );
  await enterTextInto(
    tester,
    l10n.semanticInvitePasswordField,
    E2EConfig.invitedPassword,
  );
  await enterTextInto(
    tester,
    l10n.semanticInviteConfirmPasswordField,
    E2EConfig.invitedPassword,
  );
  await tapSemantic(tester, l10n.semanticAcceptInviteButton);

  await pumpUntil(tester, find.byType(MapPage));
}

/// In-app password change with OTP reauthentication. Submitting once forces
/// the backend to send a 6-digit nonce; the test fetches it from Mailpit,
/// types it in, and submits again.
Future<void> _resetPasswordWithOtp(
  WidgetTester tester,
  MailpitClient mail,
) async {
  final l10n = _l10n(tester);

  await mail.deleteAll();

  dismissActiveNotification();
  await tester.pump(const Duration(milliseconds: 300));
  await tapSemantic(tester, l10n.semanticMapSettingsButton);
  await pumpUntil(tester, find.byType(MainSettingsPage));

  await tapSemantic(tester, l10n.semanticAccountSettingsLink);
  await pumpUntil(tester, find.byType(AccountSettingsPage));

  await tapSemantic(tester, l10n.semanticChangePasswordLink);
  await pumpUntil(tester, find.byType(PasswordChangeSettingsPage));

  await enterTextInto(
    tester,
    l10n.semanticNewPasswordField,
    E2EConfig.adminNewPassword,
  );
  await enterTextInto(
    tester,
    l10n.semanticConfirmNewPasswordField,
    E2EConfig.adminNewPassword,
  );
  await tapSemantic(tester, l10n.semanticSavePasswordButton);

  // Two valid outcomes:
  //  - The session is fresh enough that GoTrue accepts the change directly,
  //    and the page emits the success notification.
  //  - GoTrue requires reauthentication, so the page reveals a third
  //    EditableText (the OTP field) and emails a six-digit nonce. We type it
  //    in and tap save again.
  final otpFields = find.descendant(
    of: find.byType(PasswordChangeSettingsPage),
    matching: find.byType(EditableText),
  );
  final success = find.text(l10n.passwordChangeSuccess);
  final deadline = DateTime.now().add(E2EConfig.networkTimeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (success.evaluate().isNotEmpty) {
      return;
    }
    if (otpFields.evaluate().length >= 3) {
      final message = await mail.waitForLatestTo(E2EConfig.adminEmail);
      await tester.enterText(otpFields.at(2), message.otpCode);
      await tester.pump(const Duration(milliseconds: 100));
      await tapSemantic(tester, l10n.semanticSavePasswordButton);
      await pumpUntil(tester, success);
      return;
    }
  }
  fail('Neither password-change success nor an OTP field appeared');
}

/// In-app email update: opens account settings, submits a new email, and
/// verifies GoTrue emitted the confirmation email Supabase sends to the new
/// address. We don't follow the confirmation link — the cubit's
/// [VerificationEmailSent] state plus the captured message together prove the
/// flow reached the backend and the backend issued the confirmation.
Future<void> _changeEmail(WidgetTester tester, MailpitClient mail) async {
  await pumpUntil(tester, find.byType(MapPage));
  final l10n = _l10n(tester);

  await mail.deleteAll();
  dismissActiveNotification();
  await tester.pump(const Duration(milliseconds: 300));

  await tapSemantic(tester, l10n.semanticMapSettingsButton);
  await pumpUntil(tester, find.byType(MainSettingsPage));

  await tapSemantic(tester, l10n.semanticAccountSettingsLink);
  await pumpUntil(tester, find.byType(AccountSettingsPage));

  await enterTextInto(
    tester,
    l10n.semanticNewEmailAddressField,
    E2EConfig.adminUpdatedEmail,
  );
  await tapSemantic(tester, l10n.semanticSaveEmailAddressButton);

  // Supabase sends a confirm-change message to the NEW address.
  final message = await mail.waitForLatestTo(E2EConfig.adminUpdatedEmail);
  expect(
    message.subject.toLowerCase(),
    anyOf(contains('confirm'), contains('change'), contains('email')),
    reason: 'Email change confirmation subject was "${message.subject}"',
  );
  await pumpUntil(tester, find.text(l10n.checkInboxForVerificationMail));
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AppLocalizations _l10n(WidgetTester tester) {
  final context = tester.element(find.byType(Navigator).first);
  return AppLocalizations.of(context)!;
}

/// Issues an unfollowed GET to GoTrue's verify endpoint and returns the
/// redirect target (which carries `refresh_token` in its fragment).
Future<Uri> _resolveInviteRedirect(Uri verifyUrl) async {
  // GoTrue emits links pointing at `${apiExternalUrl}/verify`, but Kong only
  // routes `/auth/v1/verify`. Rewrite once before issuing the request.
  final routed = verifyUrl.path.startsWith('/auth/v1/')
      ? verifyUrl
      : verifyUrl.replace(path: '/auth/v1${verifyUrl.path}');
  // Hop over the docker host so the simulator can reach Kong with whatever
  // host the test config points at.
  final viaSimulator = routed.replace(
    scheme: Uri.parse(E2EConfig.serverUrl).scheme,
    host: Uri.parse(E2EConfig.serverUrl).host,
    port: Uri.parse(E2EConfig.serverUrl).port,
  );

  final client = HttpClient();
  try {
    final request = await client.getUrl(viaSimulator);
    request.followRedirects = false;
    final response = await request.close();
    final location = response.headers.value('location');
    await response.drain<void>();
    if (location == null) {
      throw StateError(
        'Invite verify did not redirect: ${response.statusCode}',
      );
    }
    return viaSimulator.resolve(location);
  } finally {
    client.close(force: true);
  }
}
