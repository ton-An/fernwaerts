part of 'location_history_theme.dart';

/*
  To-Dos:
  - [ ] Organize colors
*/

/// __Location History Color Theme Data__
///
/// A collection of Cupertino colors for the [LocationHistoryTheme].
class LocationHistoryColorThemeData {
  const LocationHistoryColorThemeData({
    this.primary = LocationHistoryColors.primary,
    this.primaryContrast = LocationHistoryColors.white,
    this.accent = LocationHistoryColors.accent,
    this.translucentBackground = LocationHistoryColors.translucentBackground,
    this.cameraViewBackground = LocationHistoryColors.cameraViewBackground,
    this.text = LocationHistoryColors.black,
    this.buttonLabel = LocationHistoryColors.white,
    this.description = LocationHistoryColors.description,
    this.activityIndicator = LocationHistoryColors.white,
    this.fieldColor = LocationHistoryColors.lightGray,
    this.background = LocationHistoryColors.white,
    this.error = LocationHistoryColors.red,
    this.success = LocationHistoryColors.green,
    this.border = LocationHistoryColors.border,
    this.hint = LocationHistoryColors.hint,
    this.disabledButton = LocationHistoryColors.disabled,
    this.transparent = LocationHistoryColors.transparent,
    this.backgroundContrast = LocationHistoryColors.black,
  });

  final Color primary;
  final Color primaryContrast;
  final Color accent;
  final Color translucentBackground;
  final Color cameraViewBackground;
  final Color text;
  final Color buttonLabel;
  final Color description;
  final Color activityIndicator;
  final Color fieldColor;
  final Color background;
  final Color error;
  final Color success;
  final Color border;
  final Color hint;
  final Color disabledButton;
  final Color transparent;
  final Color backgroundContrast;
}
