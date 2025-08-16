import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fernwärts'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A simple app to track your location history.\nIt is open source, is self hosted and a blast to use.'**
  String get appDescription;

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @activityTypeWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get activityTypeWalking;

  /// No description provided for @activityTypeCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get activityTypeCycling;

  /// No description provided for @activityTypeRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get activityTypeRunning;

  /// No description provided for @activityTypeDriving.
  ///
  /// In en, this message translates to:
  /// **'Driving'**
  String get activityTypeDriving;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @yourHistory.
  ///
  /// In en, this message translates to:
  /// **'Your History'**
  String get yourHistory;

  /// No description provided for @serverDetails.
  ///
  /// In en, this message translates to:
  /// **'Server Details'**
  String get serverDetails;

  /// No description provided for @serverDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the URL of your server'**
  String get serverDetailsDescription;

  /// No description provided for @serverDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'It should look like this: https://example.com'**
  String get serverDetailsHint;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server Url'**
  String get serverUrl;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your username and password'**
  String get signInDescription;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @createAdmin.
  ///
  /// In en, this message translates to:
  /// **'Create Admin'**
  String get createAdmin;

  /// No description provided for @adminSignUpDescription.
  ///
  /// In en, this message translates to:
  /// **'You are accessing a fresh install.\nPlease create an admin account.'**
  String get adminSignUpDescription;

  /// No description provided for @openStreetMapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap'**
  String get openStreetMapAttribution;

  /// No description provided for @proudlyOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Proudly Open Source'**
  String get proudlyOpenSource;

  /// No description provided for @openSourceExplanation.
  ///
  /// In en, this message translates to:
  /// **'This means that the source code is publicly available. You are invited to contribute, report bugs or suggest new features.'**
  String get openSourceExplanation;

  /// No description provided for @debugger.
  ///
  /// In en, this message translates to:
  /// **'Debugger'**
  String get debugger;

  /// No description provided for @doubleTapToOpenLogPage.
  ///
  /// In en, this message translates to:
  /// **'Double tap to open log page'**
  String get doubleTapToOpenLogPage;

  /// No description provided for @signOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign Out?'**
  String get signOutQuestion;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ll be signed out of your account. You can sign back in anytime :)'**
  String get signOutMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @userManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your users and create new ones'**
  String get userManagementDescription;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @authenticationDescription.
  ///
  /// In en, this message translates to:
  /// **'Change your password or email address.'**
  String get authenticationDescription;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @createNewUser.
  ///
  /// In en, this message translates to:
  /// **'Create new User'**
  String get createNewUser;

  /// No description provided for @yourUsers.
  ///
  /// In en, this message translates to:
  /// **'Your Users'**
  String get yourUsers;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'E-Mail Sent'**
  String get emailSent;

  /// No description provided for @checkInboxForVerificationMail.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox for the verification email.'**
  String get checkInboxForVerificationMail;

  /// No description provided for @newPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Your new passwords do not match'**
  String get newPasswordsDoNotMatch;

  /// No description provided for @passwordChange.
  ///
  /// In en, this message translates to:
  /// **'Password Change'**
  String get passwordChange;

  /// No description provided for @passwordChangeDescription.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be at least 8 characters long. It should contain a number, an uppercase letter and a lowercase letter.'**
  String get passwordChangeDescription;

  /// No description provided for @otpPassword.
  ///
  /// In en, this message translates to:
  /// **'OTP Password'**
  String get otpPassword;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @passwordChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get passwordChangeSuccess;

  /// No description provided for @newEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'New E-Mail Address'**
  String get newEmailAddress;

  /// No description provided for @inviteNewUser.
  ///
  /// In en, this message translates to:
  /// **'Invite New User'**
  String get inviteNewUser;

  /// No description provided for @inviteNewUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Invite a new user via email.'**
  String get inviteNewUserDescription;

  /// No description provided for @usersEmail.
  ///
  /// In en, this message translates to:
  /// **'Users Email'**
  String get usersEmail;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
