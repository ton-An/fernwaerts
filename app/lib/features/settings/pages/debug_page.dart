import 'package:flutter/widgets.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template debug_page}
/// A page that displays debug content.
/// {@endtemplate}
class DebugPage extends StatelessWidget {
/// {@macro debug_page}
  const DebugPage({super.key});

  static const String pageName = 'debug';
  static const String route = '/$pageName';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    final Talker talker = getIt<Talker>();

    return TalkerScreen(
      talker: talker,
      appBarTitle: AppLocalizations.of(context)!.debugger,
      theme: TalkerScreenTheme(
        backgroundColor: theme.colors.background,
        textColor: theme.colors.text,
        cardColor: theme.colors.fieldColor,
      ),
    );
  }
}
