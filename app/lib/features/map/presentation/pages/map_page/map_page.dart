import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/misc/date_time_extensions.dart';
import 'package:location_history/core/widgets/fade_tap_detector.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_composite/calendar_composite.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';
import 'package:location_history/features/map/presentation/widgets/location_history_modal/location_history_modal.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_attribution_legend.dart';
part '_legend_container.dart';
part '_location_markers.dart';
part '_map.dart';
part '_modal.dart';
part '_single_location_marker.dart';
part '_time_gradient_legend.dart';

/// {@template map_page}
/// The main page of the application, displaying the map, calendar, and location history modal.
///
/// This page integrates several key features:
/// - **Map View**: Displays a geographical map using `flutter_map` (via `_Map`).
///   - Shows location markers for the selected date range (via `_LocationMarkers`).
///   - Includes attribution and time gradient legends (via `_AttributionLegend`, `_TimeGradientLegend`).
/// - **Calendar**: Allows users to select dates or date ranges for viewing location history (via [CalendarComposite]).
/// - **Location History Modal**: A draggable bottom sheet that displays detailed location history (via `_Modal` which wraps [LocationHistoryModal]).
///
/// State Management:
/// - Listens to [CalendarDateSelectionCubit] to load location data via [MapCubit] when the selected date changes.
/// - [MapCubit] manages fetching and providing location data to the map and modal.
///
/// Initialization:
/// - On `initState`, it triggers an initial load of locations based on the current state of [CalendarDateSelectionCubit].
///
/// Sub-components:
/// - [_Map]: The core map widget.
/// - [_LocationMarkers]: Renders markers on the map.
/// - [_SingleLocationMarker]: Represents an individual marker.
/// - [_AttributionLegend]: Displays map attribution information.
/// - [_TimeGradientLegend]: Shows a legend for the time-based color gradient of location markers.
/// - [_LegendContainer]: A common container for map legends.
/// - [CalendarComposite]: The interactive calendar widget.
/// - [_Modal]: Manages the presentation of the [LocationHistoryModal].
/// {@endtemplate}
class MapPage extends StatefulWidget {
  /// {@macro map_page}
  const MapPage({super.key});

  static const String pageName = 'map';
  static const String route = '/$pageName';

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();

    final CalendarDateSelectionState dateSelectionState =
        context.read<CalendarDateSelectionCubit>().state;

    _loadLocations(dateSelectionState);
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocListener<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      listener: (
        BuildContext context,
        CalendarDateSelectionState dateSelectionState,
      ) {
        _loadLocations(dateSelectionState);
      },
      child: Stack(
        children: [
          const Positioned.fill(child: _Map()),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.medium,
                  ),
                  child: const CalendarComposite(),
                ),
              ),
              const _Modal(),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadLocations(
    CalendarDateSelectionState dateSelectionState,
  ) async {
    DateTime? startDate;
    DateTime? endDate;

    if (dateSelectionState is CalendarRangeSelected) {
      startDate = dateSelectionState.startDate;
      endDate = dateSelectionState.endDate;
    } else if (dateSelectionState is CalendarDaySelected) {
      startDate = dateSelectionState.selectedDate;
      endDate = dateSelectionState.selectedDate.endOfDay();
    }

    if (startDate != null && endDate != null) {
      context.read<MapCubit>().loadLocationsByDate(
        start: startDate,
        end: endDate,
      );
    }
  }
}
