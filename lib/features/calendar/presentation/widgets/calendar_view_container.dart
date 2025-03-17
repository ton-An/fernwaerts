import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class CalendarViewContainer extends StatelessWidget {
  const CalendarViewContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, selectionTypeState) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left:
                selectionTypeState is CalendarMonthSelection ||
                        selectionTypeState is CalendarYearSelection
                    ? theme.spacing.xSmall
                    : theme.spacing.small,
            top: theme.spacing.xSmall,
            right: theme.spacing.xSmall,
            bottom: theme.spacing.xSmall,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              WebfabrikTheme.of(context).radii.medium,
            ),
            color: theme.colors.translucentBackground,
          ),
          child: child,
        );
      },
    );
  }
}
