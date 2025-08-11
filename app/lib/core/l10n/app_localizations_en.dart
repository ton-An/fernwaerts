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
      'Manage your users and create new ones';

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
  String get emailSent => 'E-Mail Sent';

  @override
  String get checkInboxForVerificationMail =>
      'Check your inbox for the verification email.';
}
