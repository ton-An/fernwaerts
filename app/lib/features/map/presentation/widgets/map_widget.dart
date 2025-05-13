import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_history/core/misc/date_time_extensions.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

    _setAppPackageName();

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

  Future<void> _setAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appPackageName = packageInfo.packageName;
    });
  }

  final List<LatLng> _points = [];

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
            final points = <LatLng>[];
            for (final location in mapState.locations) {
              points.add(
                LatLng(
                  location.latitude.toDouble(),
                  location.longitude.toDouble(),
                ),
              );
            }

            setState(() {
              _points.clear();
              _points.addAll(points);
            });
          }
        },
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(50.14568, 9.96024),
            initialZoom: 6,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: appPackageName ?? 'location_history',
            ),
            CircleLayer(
              circles: [
                for (final LatLng point in _points)
                  CircleMarker(
                    point: point,
                    radius: 10,
                    color: theme.colors.primary,
                    borderStrokeWidth: 10,
                    borderColor: theme.colors.primaryTranslucent,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
