// ignore_for_file: must_be_immutable

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'raw_location_data'),
)
/// {@template location}
/// A class that represents location.
/// {@endtemplate}
class Location extends OfflineFirstWithSupabaseModel with EquatableMixin {
/// {@macro location}
  Location({
    String? id,
    required this.userId,
    required this.deviceId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.coordinatesAccuracy,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.headingAccuracy,
    required this.ellipsoidalAltitude,
    required this.altitudeAccuracy,
    required this.activityType,
    required this.activityConfidence,
    required this.batteryLevel,
    required this.isDeviceCharging,
  }) : id = id ?? (const Uuid()).v4();

  @Sqlite(unique: true)
  @Supabase(unique: true)
  final String id;

  final String userId;
  final String deviceId;

  final DateTime timestamp;

  final num latitude;
  final num longitude;
  final num coordinatesAccuracy;

  final num speed;
  final num speedAccuracy;

  final num heading;
  final num headingAccuracy;

  final num ellipsoidalAltitude;
  final num altitudeAccuracy;

  @Supabase(
    name: 'activity_type_id',
    enumAsString: true,
    fromGenerator: '''
    ActivityType.values.firstWhere((value) {
      if(value.toString() == %DATA_PROPERTY%) return true;

      return false;
    }, orElse: () => throw ArgumentError.value(%DATA_PROPERTY%, "name", "No enum value with that name"))''',
    toGenerator: '%INSTANCE_PROPERTY%.toString()',
  )
  final ActivityType activityType;
  final num activityConfidence;

  final num batteryLevel;
  final bool isDeviceCharging;

  static Location fromRecordedLocation({
    required RecordedLocation recordedLocation,
    required String userId,
    required String deviceId,
  }) {
    return Location(
      userId: userId,
      deviceId: deviceId,
      timestamp: recordedLocation.timestamp,
      latitude: recordedLocation.latitude,
      longitude: recordedLocation.longitude,
      coordinatesAccuracy: recordedLocation.coordinatesAccuracy,
      speed: recordedLocation.speed,
      speedAccuracy: recordedLocation.speedAccuracy,
      heading: recordedLocation.heading,
      headingAccuracy: recordedLocation.headingAccuracy,
      ellipsoidalAltitude: recordedLocation.ellipsoidalAltitude,
      altitudeAccuracy: recordedLocation.altitudeAccuracy,
      activityType: recordedLocation.activityType,
      activityConfidence: recordedLocation.activityConfidence,
      batteryLevel: recordedLocation.batteryLevel,
      isDeviceCharging: recordedLocation.isDeviceCharging,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    deviceId,
    timestamp,
    latitude,
    longitude,
    coordinatesAccuracy,
    speed,
    speedAccuracy,
    heading,
    headingAccuracy,
    ellipsoidalAltitude,
    altitudeAccuracy,
    activityType,
    activityConfidence,
    batteryLevel,
    isDeviceCharging,
  ];
}
