import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_history/core/misc/date_time_extensions.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';
import 'package:package_info_plus/package_info_plus.dart';

/* 
  To-Do:
    - [ ] Improve implementation of gradient (include theme etc..)
*/
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

          if (mapState is MapLocationsError) {
            context.read<InAppNotificationCubit>().sendFailureNotification(
              mapState.failure,
            );
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
                for (int i = 0; i < _points.length; i++)
                  CircleMarker(
                    point: _points[i],
                    radius: 10,
                    color: interpolateColors([
                      Colors.purple,
                      Colors.blue,
                      Colors.teal,
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ], i / _points.length),
                    borderStrokeWidth: 8,
                    borderColor: interpolateColors([
                      Colors.purple,
                      Colors.blue,
                      Colors.teal,
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ], i / _points.length).withValues(alpha: .3),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color interpolateColors(List<Color> colors, double t) {
    if (colors.isEmpty) throw ArgumentError('Colors list cannot be empty');
    if (colors.length == 1 || t <= 0.0) return colors.first;
    if (t >= 1.0) return colors.last;

    final segmentLength = 1.0 / (colors.length - 1);
    final segmentIndex = (t / segmentLength).floor();
    final localT = (t - (segmentIndex * segmentLength)) / segmentLength;

    final colorStart = colors[segmentIndex];
    final colorEnd = colors[segmentIndex + 1];

    Color color = Color.lerp(colorStart, colorEnd, localT)!;

    return color;
  }
}
