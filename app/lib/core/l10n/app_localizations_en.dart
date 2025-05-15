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
  String get appDescription => 'A simple app to track your location history.\nIt is open source, is self hosted and a blast to use.';

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
  String get serverDetailsHint => 'It should look like this: https://example.com';

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
  String get adminSignUpDescription => 'You are accessing a fresh install.\nPlease create an admin account.';

  @override
  String get openStreetMapAttribution => '© OpenStreetMap';
}
