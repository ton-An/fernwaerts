import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_layout_render_object_widget.dart';

class CalendarComposite extends StatefulWidget {
  const CalendarComposite({super.key});

  @override
  State<CalendarComposite> createState() => _CalendarCompositeState();
}

class _CalendarCompositeState extends State<CalendarComposite>
    with TickerProviderStateMixin {
  late AnimationController _translateAnimationController;
  late AnimationController _fadeAnimationController;

  late Animation<double> _translateAnimation;
  late Animation<double> _fadeAnimation;

  CalendarSelectionTypeState? _lastSelectionTypeState;

  @override
  void initState() {
    super.initState();

    _translateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 580),
    );

    _translateAnimationController.addListener(() {
      setState(() {});
    });

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _fadeAnimationController.addListener(() {
      setState(() {});
    });

    _translateAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _translateAnimationController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _translateAnimationController.dispose();
    _fadeAnimationController.dispose();
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
              _translateAnimationController.reverse();
              _fadeAnimationController.reverse();
            }

            if (expansionState is CalendarExpanded) {
              _translateAnimationController.forward();
              _fadeAnimationController.forward();

              final bool hasMovedRange =
                  context.read<CalendarDateSelectionCubit>().hasMovedRange;

              if (hasMovedRange) {
                final DateTime? selectionStart = _getStartDateOfSelection(
                  context,
                );

                if (selectionStart != null) {
                  if (selectionTypeState is CalendarRangeSelection ||
                      selectionTypeState is CalendarDaySelection ||
                      selectionTypeState is CalendarWeekSelection) {
                    context.read<MonthlyCalendarCubit>().showMonth(
                      selectionStart,
                    );
                  } else if (selectionTypeState is CalendarMonthSelection) {
                    context.read<YearlyCalendarCubit>().showYear(
                      selectionStart,
                    );
                  } else if (selectionTypeState is CalendarYearSelection) {
                    context.read<DecenniallyCalendarCubit>().showDecade(
                      selectionStart,
                    );
                  }
                }
              }
              context.read<CalendarDateSelectionCubit>().resetHasMovedRange();
            }
          },
          builder: (context, state) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                WebfabrikTheme.of(context).radii.medium,
              ),
              child: _LayoutRenderObjectWidget(
                itemSpacing: WebfabrikTheme.of(context).spacing.medium,
                calendarOffset: _translateAnimation.value,
                children: [
                  const CalendarStepper(),
                  if (!(_translateAnimationController.status ==
                          AnimationStatus.dismissed &&
                      _fadeAnimationController.status ==
                          AnimationStatus.dismissed))
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: const Calendar(),
                    ),
                ],
              ),
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
