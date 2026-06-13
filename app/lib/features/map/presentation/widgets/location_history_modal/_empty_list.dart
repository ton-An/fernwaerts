part of 'location_history_modal.dart';

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return ListView(
      padding: EdgeInsets.all(theme.spacing.xMedium),
      shrinkWrap: true,
      controller: scrollController,
      children: [
        Center(
          child: Text(
            AppLocalizations.of(context)!.noData,
            style: theme.text.title3.copyWith(
              color: theme.colors.text.withValues(alpha: .4),
            ),
          ),
        ),
      ],
    );
  }
}
