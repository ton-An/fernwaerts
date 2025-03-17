import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location_history/features/map/presentation/pages/map_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_footer.dart';
part '_page_container.dart';
part '_section_title.dart';
part '_sub_page_link.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String pageName = "settings";
  static const String route = "${MapPage.route}/$pageName";

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return _PageContainer(
      child: Column(
        children: [
          Expanded(
            child: EdgeFade(
              topOptions: EdgeFadeOptions(enabled: false),
              child: ListView(
                padding: EdgeInsets.only(
                  left: theme.spacing.medium,
                  top: MediaQuery.of(context).padding.top,
                  right: theme.spacing.medium,
                  bottom: theme.spacing.xMedium,
                ),
                children: [
                  _SectionTitle(title: AppLocalizations.of(context)!.general),
                  _SubPageLink(),
                  _SubPageLink(),
                  _SubPageLink(),
                  _SectionTitle(title: AppLocalizations.of(context)!.account),
                  _SubPageLink(),
                  _SubPageLink(),
                  _SectionTitle(title: AppLocalizations.of(context)!.admin),
                  _SubPageLink(),
                  _SubPageLink(),
                ],
              ),
            ),
          ),
          _Footer(),
        ],
      ),
    );
  }
}
