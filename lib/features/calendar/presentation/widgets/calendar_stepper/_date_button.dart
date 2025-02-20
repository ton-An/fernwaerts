part of "calendar_stepper.dart";

enum _LabelSize { small, medium, large }

class _DateButton extends StatefulWidget {
  const _DateButton();

  @override
  State<_DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<_DateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<int> _fadeAnimation;

  _LabelSize _labelSize = _LabelSize.large;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 160),
      reverseDuration: const Duration(milliseconds: 220),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ).drive(IntTween(begin: 0, end: 18));

    _fadeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return BlocBuilder<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      builder: (context, dateSelectionState) {
        final String dateString = _getDateString(context, dateSelectionState);
        return BlocBuilder<CalendarExpansionCubit, CalendarExpansionState>(
          builder: (context, expansionState) {
            return GestureDetector(
              onTapDown: (_) {
                _fadeController.forward();
              },
              onTapUp: (_) {
                _fadeController.forward().then((_) {
                  _fadeController.reverse();
                });

                context.read<CalendarExpansionCubit>().toggleExpansion();
              },
              onTapCancel: () {
                _fadeController.forward().then((_) {
                  _fadeController.reverse();
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.radii.medium),
                child: Container(
                  height: CalendarStepper.height,
                  color: theme.colors.background,
                  child: ColoredBox(
                    color: theme.colors.text.withAlpha(_fadeAnimation.value),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dateString,
                          textAlign: TextAlign.center,
                          style: _getLabelStyle(theme),
                        ),
                        SizedBox(width: theme.spacing.xSmall),
                        AnimatedRotation(
                          duration: Duration(milliseconds: 200),
                          turns: expansionState is CalendarCollapsed ? 0 : .5,
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: theme.colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  TextStyle _getLabelStyle(LocationHistoryThemeData theme) {
    final TextStyle largeLabelStyle =
        theme.text.title3.copyWith(fontWeight: FontWeight.w600);

    switch (_labelSize) {
      case _LabelSize.small:
        return theme.text.headline.copyWith(
          fontSize: theme.text.headline.fontSize! - .5,
        );
      case _LabelSize.medium:
        return largeLabelStyle.copyWith(
          fontSize: largeLabelStyle.fontSize! - 1.5,
        );
      case _LabelSize.large:
        return largeLabelStyle;
    }
  }

  String _getDateString(
      BuildContext context, CalendarDateSelectionState dateSelectionState) {
    if (dateSelectionState is CalendarDaySelected) {
      _labelSize = _LabelSize.large;

      return DateFormat("d MMM y", Localizations.localeOf(context).languageCode)
          .format(dateSelectionState.selectedDate);
    }

    if (dateSelectionState is CalendarYearSelected) {
      _labelSize = _LabelSize.large;
      return DateFormat.y(Localizations.localeOf(context).languageCode)
          .format(dateSelectionState.startDate!);
    }

    if (dateSelectionState is CalendarRangeSelected) {
      if (dateSelectionState.startDate == null &&
              dateSelectionState.endDate != null ||
          dateSelectionState.endDate == null &&
              dateSelectionState.startDate != null) {
        _labelSize = _LabelSize.large;
        return DateFormat(
                "d MMM y", Localizations.localeOf(context).languageCode)
            .format(
                dateSelectionState.startDate ?? dateSelectionState.endDate!);
      }

      if (dateSelectionState.startDate != null &&
          dateSelectionState.endDate != null) {
        if (dateSelectionState.startDate!.year ==
            dateSelectionState.endDate!.year) {
          if (dateSelectionState.startDate!.month ==
              dateSelectionState.endDate!.month) {
            if (dateSelectionState.startDate!.day == 1 &&
                dateSelectionState.endDate!.day ==
                    DateTime(dateSelectionState.startDate!.year,
                            dateSelectionState.startDate!.month + 1, 0)
                        .day) {
              _labelSize = _LabelSize.large;
              return DateFormat(
                      "MMMM y", Localizations.localeOf(context).languageCode)
                  .format(dateSelectionState.startDate!);
            }
            _labelSize = _LabelSize.large;
            return "${DateFormat("d", Localizations.localeOf(context).languageCode).format(dateSelectionState.startDate!)} - ${DateFormat("d MMM y", Localizations.localeOf(context).languageCode).format(dateSelectionState.endDate!)}";
          }

          _labelSize = _LabelSize.medium;
          return "${DateFormat("d MMM", Localizations.localeOf(context).languageCode).format(dateSelectionState.startDate!)} - ${DateFormat("d MMM yy", Localizations.localeOf(context).languageCode).format(dateSelectionState.endDate!)}";
        }

        _labelSize = _LabelSize.small;
        return "${DateFormat("d MMM yy", Localizations.localeOf(context).languageCode).format(dateSelectionState.startDate!)} - ${DateFormat("d MMM yy", Localizations.localeOf(context).languageCode).format(dateSelectionState.endDate!)}";
      }
    }
    return "hooops :)";
  }
}
