import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/decennially_year_calendar/decennially_year_calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/monthly_calendar/monthly_calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/yearly_calendar/yearly_calendar.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_calendar_container.dart';
part '_calendar_header.dart';
part '_calendar_header_switch.dart';
part '_calendar_type_selector.dart';

/// Enum defining the different types of selection modes for the calendar.
/// This is used by `_CalendarTypeSelector` to offer different ways to select dates.
enum CalendarSelectionType { customRange, day, week, month, year }




























/// {@template calendar}
/// The main calendar view widget that allows users to select dates or date ranges.
///
/// This widget adapts its display based on the [CalendarSelectionTypeState]
/// (e.g., showing a [MonthlyCalendar], [YearlyCalendar], or [DecenniallyYearCalendar]).
/// It uses an [ExpandableCarousel] to allow swiping between different time periods
/// (e.g., months, years, decades).
///
/// Structure:
/// - **Header**: Displays the current time period and navigation arrows (via `_CalendarHeader`).
/// - **Carousel**: A swipeable area showing the appropriate calendar view ([MonthlyCalendar], [YearlyCalendar], or [DecenniallyYearCalendar]).
/// - **Type Selector**: Allows changing the selection granularity (e.g., day, week, month, year) (via `_CalendarTypeSelector`).
///
/// State Management:
/// - Listens to [CalendarSelectionTypeCubit] to determine which calendar view to display.
/// - Interacts with [MonthlyCalendarCubit], [YearlyCalendarCubit], or [DecenniallyCalendarCubit]
///   when the user swipes the carousel to load the corresponding time frame.
///
/// Sub-components:
/// - [_CalendarContainer]: Provides the main visual container for the calendar.
/// - [_CalendarHeader]: Displays the current period (e.g., "May 2023") and navigation.
///   - [_CalendarHeaderSwitch]: The interactive element in the header to change period or selection type.
/// - [MonthlyCalendar]: Displays days of a month.
/// - [YearlyCalendar]: Displays months of a year.
/// - [DecenniallyYearCalendar]: Displays years of a decade.
/// - [_CalendarTypeSelector]: Buttons to switch between different selection modes (day, week, month, etc.).
/// {@endtemplate}
class Calendar extends StatefulWidget {
  /// {@macro calendar}
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

/// {@template calendar_state}
/// A state class that represents calendar state.
/// {@endtemplate}
class _CalendarState extends State<Calendar> {
  late final ExpandableCarouselController _carouselController;
  int _lastOffsetFromCenter = 0;

  static const int _carouselItemCount = 49;
  static const int _carouselCenter = _carouselItemCount ~/ 2 + 1;

  @override
  void initState() {
    super.initState();
    _carouselController = ExpandableCarouselController();
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, selectionTypeState) {
        return _CalendarContainer(
          child: Column(
            children: [
              const _CalendarHeader(),
              ExpandableCarousel.builder(
                itemCount: _carouselItemCount,
                itemBuilder: (context, index, realIndex) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.medium,
                    ),
                    child: _buildCalendar(index, selectionTypeState),
                  );
                },
                options: ExpandableCarouselOptions(
                  controller: _carouselController,
                  viewportFraction: 1,
                  initialPage: _carouselCenter,
                  showIndicator: false,
                  autoPlayCurve: Curves.easeOut,
                  onScrolled: (value) {
                    if (value != null && value % 1 == 0) {
                      int offsetFromCenter = value.toInt() - _carouselCenter;
                      if (_lastOffsetFromCenter != offsetFromCenter &&
                          offsetFromCenter != 0) {
                        _showTimeFrameAtOffset(
                          selectionTypeState,
                          offsetFromCenter,
                        );
                        _carouselController.jumpToPage(_carouselCenter);
                        _lastOffsetFromCenter = 0;
                      }
                    }
                  },
                ),
              ),
              const XXSmallGap(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.medium),
                child: const _CalendarTypeSelector(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _buildCalendar(
    int index,
    CalendarSelectionTypeState selectionTypeState,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      return MonthlyCalendar(monthOffset: index - _carouselCenter);
    } else if (selectionTypeState is CalendarMonthSelection) {
      return YearlyCalendar(yearOffset: index - _carouselCenter);
    } else if (selectionTypeState is CalendarYearSelection) {
      return DecenniallyYearCalendar(decadeOffset: index - _carouselCenter);
    }

    return null;
  }

  void _showTimeFrameAtOffset(
    CalendarSelectionTypeState selectionTypeState,
    int offsetFromCenter,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      context.read<MonthlyCalendarCubit>().showMonthAtOffset(offsetFromCenter);
    } else if (selectionTypeState is CalendarMonthSelection) {
      context.read<YearlyCalendarCubit>().showYearAtOffset(offsetFromCenter);
    } else if (selectionTypeState is CalendarYearSelection) {
      context.read<DecenniallyCalendarCubit>().showDecadeAtOffset(
        offsetFromCenter,
      );
    }
  }
}
