import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template calendar_view_container}
/// A container widget that provides a common styling for different calendar views
/// (e.g., monthly, yearly, decennially).
///
/// This widget wraps its [child] with padding and a decorated [Container]
/// (rounded corners, translucent background). The horizontal padding adjusts
/// based on the current [CalendarSelectionTypeState] to optimize spacing for
/// different calendar granularities (e.g., less padding for month/year views
/// which might have wider cells).
/// {@endtemplate}
class CalendarViewContainer extends StatelessWidget {
  /// {@macro calendar_view_container}
  const CalendarViewContainer({super.key, required this.child});

  /// The calendar content (e.g., a grid of days, months, or years) to be displayed
  /// within this container.
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
