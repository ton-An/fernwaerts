import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/misc/date_time_extensions.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';
import 'package:maplibre/maplibre.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  String? appPackageName;

  @override
  void initState() {
    super.initState();

    final CalendarDateSelectionState dateSelectionState =
        context.read<CalendarDateSelectionCubit>().state;

    _loadLocations(dateSelectionState);
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

  final List<Point> _points = <Point>[
    Point(coordinates: Position(9.17, 47.68)),
    Point(coordinates: Position(9.17, 48)),
    Point(coordinates: Position(9, 48)),
    Point(coordinates: Position(9.5, 48)),
  ];

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocListener<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      listener: (context, dateSelectionState) {
        _loadLocations(dateSelectionState);
      },
      child: BlocListener<MapCubit, MapState>(
        listener: (context, mapState) {
          if (mapState is MapLocationsLoaded) {
            final points = <Point>[];
            for (final location in mapState.locations) {
              points.add(
                Point(
                  coordinates: Position(location.longitude, location.latitude),
                ),
              );
            }

            setState(() {
              _points.clear();
              _points.addAll(points);
            });
          }
        },
        child: MapLibreMap(
          acceptLicense: true,
          options: const MapOptions(
            initStyle:
                'https://raw.githubusercontent.com/ton-An/tilekiln-shortbread-demo/refs/heads/main/colorful.json',
          ),
          layers: [
            CircleLayer(
              points: _points,
              radius: 5,
              blur: .6,
              strokeWidth: 4,
              color: theme.colors.primary,
              strokeColor: theme.colors.primaryTranslucent,
            ),
          ],
        ),
      ),
    );
  }
}

//
