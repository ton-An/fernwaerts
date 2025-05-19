import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/widgets/fade_tap_detector.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class OSSInfo extends StatelessWidget {
  const OSSInfo({super.key});

  static const String _githubIconPath = 'assets/images/logos/github.svg';
  static const String _repositoryUrl = 'https://github.com/ton-An/fernwaerts';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return FadeTapDetector(
      onTap: () {
        launchUrlString(_repositoryUrl);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.medium,
          vertical: theme.spacing.medium + theme.spacing.xTiny,
        ),
        decoration: BoxDecoration(
          color: theme.colors.translucentBackgroundContrast,
          border: GradientBoxBorder(
            gradient: LinearGradient(colors: theme.colors.timelineGradient),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(theme.radii.medium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(_githubIconPath, width: 24),
                const XXSmallGap(),
                Text(
                  AppLocalizations.of(context)!.proudlyOpenSource,
                  style: theme.text.headline,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: theme.colors.hint,
                    ),
                  ),
                ),
              ],
            ),
            const XXSmallGap(),
            Text(
              AppLocalizations.of(context)!.openSourceExplanation,
              style: theme.text.body.copyWith(color: theme.colors.hint),
            ),
          ],
        ),
      ),
    );
  }
}
