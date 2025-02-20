import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/widgets/gaps/gaps.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar/calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_stepper/calendar_stepper.dart';

class CalendarComposite extends StatefulWidget {
  const CalendarComposite({super.key});

  @override
  State<CalendarComposite> createState() => _CalendarCompositeState();
}

class _CalendarCompositeState extends State<CalendarComposite>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _translateAnimation;
  late Animation<double> _fadeAnimation;

  CalendarSelectionTypeState? _lastSelectionTypeState;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    _translateAnimation = Tween<double>(begin: -45, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      listener: (context, selectionTypeState) {
        final DateTime? selectionStart = _getStartDateOfSelection(context);
        if (selectionStart != null) {
          if (!(_lastSelectionTypeState is CalendarRangeSelection ||
                  _lastSelectionTypeState is CalendarDaySelection ||
                  _lastSelectionTypeState is CalendarWeekSelection) &&
              (selectionTypeState is CalendarRangeSelection ||
                  selectionTypeState is CalendarDaySelection ||
                  selectionTypeState is CalendarWeekSelection)) {
            context.read<MonthlyCalendarCubit>().showMonth(selectionStart);
          } else if (selectionTypeState is CalendarMonthSelection) {
            context.read<YearlyCalendarCubit>().showYear(selectionStart);
          } else if (selectionTypeState is CalendarYearSelection) {
            context.read<DecenniallyCalendarCubit>().showDecade(selectionStart);
          }
        }

        _lastSelectionTypeState = selectionTypeState;
      },
      builder: (context, selectionTypeState) {
        return BlocConsumer<CalendarExpansionCubit, CalendarExpansionState>(
          listener: (context, expansionState) {
            if (expansionState is CalendarCollapsed) {
              _animationController.reverse();
            }

            if (expansionState is CalendarExpanded) {
              _animationController.forward();

              final bool hasMovedRange =
                  context.read<CalendarDateSelectionCubit>().hasMovedRange;

              if (hasMovedRange) {
                final DateTime? selectionStart =
                    _getStartDateOfSelection(context);

                if (selectionStart != null) {
                  if (selectionTypeState is CalendarRangeSelection ||
                      selectionTypeState is CalendarDaySelection ||
                      selectionTypeState is CalendarWeekSelection) {
                    context
                        .read<MonthlyCalendarCubit>()
                        .showMonth(selectionStart);
                  } else if (selectionTypeState is CalendarMonthSelection) {
                    context
                        .read<YearlyCalendarCubit>()
                        .showYear(selectionStart);
                  } else if (selectionTypeState is CalendarYearSelection) {
                    context
                        .read<DecenniallyCalendarCubit>()
                        .showDecade(selectionStart);
                  }
                }
              }
              context.read<CalendarDateSelectionCubit>().resetHasMovedRange();
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarStepper(),
                if (_animationController.status != AnimationStatus.dismissed)
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _translateAnimation.value),
                      child: Column(
                        children: [
                          MediumGap(),
                          Calendar(),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  DateTime? _getStartDateOfSelection(BuildContext context) {
    final CalendarDateSelectionState dateSelectionState =
        context.read<CalendarDateSelectionCubit>().state;

    if (dateSelectionState is CalendarDaySelected) {
      return dateSelectionState.selectedDate;
    } else {
      return (dateSelectionState as CalendarRangeSelected).startDate;
    }
  }
}
