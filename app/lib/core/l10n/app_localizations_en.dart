// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fernwärts';

  @override
  String get appDescription =>
      'A simple app to track your location history.\nIt is open source, is self hosted and a blast to use.';

  @override
  String get range => 'Range';

  @override
  String get day => 'Day';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get activityTypeWalking => 'Walking';

  @override
  String get activityTypeCycling => 'Cycling';

  @override
  String get activityTypeRunning => 'Running';

  @override
  String get activityTypeDriving => 'Driving';

  @override
  String get general => 'General';

  @override
  String get account => 'Account';

  @override
  String get admin => 'Admin';

  @override
  String get settings => 'Settings';

  @override
  String get yourHistory => 'Your History';

  @override
  String get noData => 'No Data';

  @override
  String get serverDetails => 'Server Details';

  @override
  String get serverDetailsDescription => 'Enter the URL of your server';

  @override
  String get serverDetailsHint =>
      'It should look like this: https://example.com';

  @override
  String get continueButton => 'Continue';

  @override
  String get serverUrl => 'Server Url';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInDescription => 'Enter your username and password';

  @override
  String get signOut => 'Sign Out';

  @override
  String get username => 'Username';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get getStarted => 'Get Started';

  @override
  String get version => 'Version';

  @override
  String get createAdmin => 'Create Admin';

  @override
  String get adminSignUpDescription =>
      'You are accessing a fresh install.\nPlease create an admin account.';

  @override
  String get openStreetMapAttribution => '© OpenStreetMap';

  @override
  String get proudlyOpenSource => 'Proudly Open Source';

  @override
  String get openSourceExplanation =>
      'This means that the source code is publicly available. You are invited to contribute, report bugs or suggest new features.';

  @override
  String get debugger => 'Debugger';

  @override
  String get doubleTapToOpenLogPage => 'Double tap to open log page';

  @override
  String get signOutQuestion => 'Sign Out?';

  @override
  String get signOutMessage =>
      'You’ll be signed out of your account. You can sign back in anytime :)';

  @override
  String get yes => 'Yes';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get accountDetails => 'Account Details';

  @override
  String get authentication => 'Authentication';

  @override
  String get userManagement => 'User Management';

  @override
  String get userManagementDescription =>
      'Manage your users and invite new ones';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get authenticationDescription =>
      'Change your password or email address.';

  @override
  String get changePassword => 'Change Password';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get createNewUser => 'Create new User';

  @override
  String get yourUsers => 'Your Users';

  @override
  String get users => 'Users';

  @override
  String get invitePending => 'Invite pending';

  @override
  String get pending => 'Pending';

  @override
  String get emailSent => 'E-Mail Sent';

  @override
  String get checkInboxForVerificationMail =>
      'Check your inbox for the verification email.';

  @override
  String get newPasswordsDoNotMatch => 'Your new passwords do not match';

  @override
  String get passwordChange => 'Password Change';

  @override
  String get passwordChangeDescription =>
      'Your new password must be at least 8 characters long. It should contain a number, an uppercase letter and a lowercase letter.';

  @override
  String get otpPassword => 'OTP Password';

  @override
  String get success => 'Success';

  @override
  String get passwordChangeSuccess =>
      'Your password has been changed successfully.';

  @override
  String get newEmailAddress => 'New E-Mail Address';

  @override
  String get inviteNewUser => 'Invite New User';

  @override
  String get inviteNewUserDescription => 'Invite a new user via email.';

  @override
  String get usersEmail => 'User\'s Email';

  @override
  String get invite => 'Invite';

  @override
  String get inviteNewUserSuccess => 'The user has been invited via email.';

  @override
  String get acceptInvite => 'Accept Invite';

  @override
  String get acceptInviteDescription =>
      'Enter your username and password to accept the invite.';

  @override
  String get accept => 'Accept';

  @override
  String get semanticGetStartedButton => 'Get started';

  @override
  String get semanticServerUrlField => 'Server URL';

  @override
  String get semanticServerContinueButton => 'Continue with server URL';

  @override
  String get semanticAdminUsernameField => 'Admin username';

  @override
  String get semanticAdminEmailField => 'Admin email';

  @override
  String get semanticAdminPasswordField => 'Admin password';

  @override
  String get semanticAdminConfirmPasswordField => 'Confirm admin password';

  @override
  String get semanticCreateAdminButton => 'Create initial admin';

  @override
  String get semanticSignInEmailField => 'Sign in email';

  @override
  String get semanticSignInPasswordField => 'Sign in password';

  @override
  String get semanticSignInButton => 'Sign in';

  @override
  String get semanticInviteUsernameField => 'Invited user username';

  @override
  String get semanticInvitePasswordField => 'Invited user password';

  @override
  String get semanticInviteConfirmPasswordField =>
      'Confirm invited user password';

  @override
  String get semanticAcceptInviteButton => 'Accept invite';

  @override
  String get semanticAuthenticationBackButton =>
      'Go back in authentication flow';

  @override
  String get semanticMapSettingsButton => 'Open settings';

  @override
  String get semanticAccountSettingsLink => 'Open account settings';

  @override
  String get semanticUserManagementLink => 'Open user management';

  @override
  String get semanticInviteNewUserLink => 'Open invite new user';

  @override
  String get semanticInviteNewUserEmailField => 'Invite user email';

  @override
  String get semanticInviteNewUserButton => 'Send user invite';

  @override
  String get semanticChangePasswordLink => 'Open change password';

  @override
  String get semanticNewEmailAddressField => 'New email address';

  @override
  String get semanticSaveEmailAddressButton => 'Save email address';

  @override
  String get semanticNewPasswordField => 'New password';

  @override
  String get semanticConfirmNewPasswordField => 'Confirm new password';

  @override
  String get semanticSavePasswordButton => 'Save new password';

  @override
  String get semanticSignOutButton => 'Sign out';

  @override
  String get semanticConfirmDialogActionButton => 'Confirm dialog action';

  @override
  String get semanticCancelDialogActionButton => 'Cancel dialog action';

  @override
  String get semanticSettingsFooterBackButton => 'Go back in settings';

  @override
  String get semanticCalendarPreviousButton => 'Show previous calendar period';

  @override
  String get semanticCalendarNextButton => 'Show next calendar period';

  @override
  String get semanticCalendarStepperPreviousButton => 'Move selection backward';

  @override
  String get semanticCalendarStepperNextButton => 'Move selection forward';

  @override
  String get semanticCalendarDateButton => 'Toggle calendar picker';

  @override
  String get semanticOpenSourceLink => 'Open source repository';

  @override
  String get semanticOpenStreetMapAttributionLink =>
      'Open OpenStreetMap attribution';

  @override
  String get semanticNotification => 'In-app notification';

  @override
  String get semanticNotificationDismiss => 'Dismiss notification';

  @override
  String get semanticLocationListItem => 'Show location on map';
}
