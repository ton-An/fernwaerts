import 'package:elevated_flex/elevated_flex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_date_button.dart';
part '_switch.dart';

/// {@template calendar_stepper}
/// A widget that allows users to navigate between different time periods in the calendar.
///
/// It consists of:
/// - **Previous Button**: Navigates to the previous time period (e.g., previous month, year).
/// - **Date Display Button**: Shows the currently selected date/range and toggles the calendar expansion.
/// - **Next Button**: Navigates to the next time period.
///
/// The stepper uses a [ClipRRect] for rounded corners and a [BackdropFilter]
/// for a blurred background effect. The layout is managed using [ElevatedRow]
/// and [Elevated] from the `elevated_flex` package for consistent elevation
/// and spacing.
///
/// Interactions:
/// - Tapping the previous/next buttons calls `moveRange` on [CalendarDateSelectionCubit].
/// - Tapping the date display button (handled by `_DateButton`) interacts with
///   [CalendarExpansionCubit] to toggle the calendar view.
///
/// Sub-components:
/// - [_Switch]: Represents the previous and next navigation buttons.
/// - [_DateButton]: Displays the current date and handles expansion toggle.
/// {@endtemplate}
class CalendarStepper extends StatelessWidget {
  /// {@macro calendar_stepper}
  const CalendarStepper({super.key});

  /// The fixed height of the calendar stepper.
  static const double height = 60;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        WebfabrikTheme.of(context).radii.medium,
      ),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: Container(
          decoration: BoxDecoration(color: theme.colors.translucentBackground),
          child: Stack(
            children: [
              ElevatedRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Switch(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: () {
                      context.read<CalendarDateSelectionCubit>().shiftSelection(
                        forward: false,
                      );
                    },
                  ),
                  const Elevated(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: height),
                      child: _DateButton(),
                    ),
                  ),
                  _Switch(
                    icon: Icons.arrow_forward_ios_rounded,
                    onPressed: () {
                      context.read<CalendarDateSelectionCubit>().shiftSelection(
                        forward: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
