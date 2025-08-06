// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:uuid/uuid.dart';

class Location extends Equatable {
  factory Location.fromDb({
    required String id,
    required String userId,
    required String deviceId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required double coordinatesAccuracy,
    required double speed,
    required double speedAccuracy,
    required double heading,
    required double headingAccuracy,
    required double ellipsoidalAltitude,
    required double altitudeAccuracy,
    required ActivityType activityType,
    required double activityConfidence,
    required double batteryLevel,
    required bool isDeviceCharging,
  }) {
    return Location(
      id: id,
      userId: userId,
      deviceId: deviceId,
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      coordinatesAccuracy: coordinatesAccuracy,
      speed: speed,
      speedAccuracy: speedAccuracy,
      heading: heading,
      headingAccuracy: headingAccuracy,
      ellipsoidalAltitude: ellipsoidalAltitude,
      altitudeAccuracy: altitudeAccuracy,
      activityType: activityType,
      activityConfidence: activityConfidence,
      batteryLevel: batteryLevel,
      isDeviceCharging: isDeviceCharging,
    );
  }

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

  final String id;

  final String userId;
  final String deviceId;

  final DateTime timestamp;

  final double latitude;
  final double longitude;
  final double coordinatesAccuracy;

  final double speed;
  final double speedAccuracy;

  final double heading;
  final double headingAccuracy;

  final double ellipsoidalAltitude;
  final double altitudeAccuracy;

  final ActivityType activityType;
  final double activityConfidence;

  final double batteryLevel;
  final bool isDeviceCharging;

  static Location fromRecordedLocation({
    required RecordedLocation recordedLocation,
    required String userId,
    required String deviceId,
    required ActivityType activityType,
    required double activityConfidence,
    required double batteryLevel,
    required bool isDeviceCharging,
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
      activityType: activityType,
      activityConfidence: activityConfidence,
      batteryLevel: batteryLevel,
      isDeviceCharging: isDeviceCharging,
    );
  }

  @override
  List<Object?> get props => [
    id,
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
