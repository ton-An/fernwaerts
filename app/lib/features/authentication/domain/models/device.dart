import 'package:equatable/equatable.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';
import 'package:uuid/uuid.dart';

class Device extends Equatable {
  Device({
    String? id,
    required this.userId,
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.operatingSystem,
    required this.osVersion,
    required this.appVersion,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? (const Uuid()).v4();

  factory Device.fromDb({
    required String id,
    required String userId,
    required String name,
    required String model,
    required String manufacturer,
    required OperatingSystem operatingSystem,
    required String osVersion,
    required String appVersion,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return Device(
      id: id,
      userId: userId,
      name: name,
      model: model,
      manufacturer: manufacturer,
      operatingSystem: operatingSystem,
      osVersion: osVersion,
      appVersion: appVersion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  final String id;
  final String userId;
  final String name;
  final String model;
  final String manufacturer;
  final OperatingSystem operatingSystem;
  final String osVersion;
  final String appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  static Device fromRawDevice({
    required RawDevice rawDevice,
    required String appVersion,
    required String userId,
  }) {
    final DateTime now = DateTime.now();

    return Device(
      userId: userId,
      name: rawDevice.name,
      model: rawDevice.model,
      manufacturer: rawDevice.manufacturer,
      operatingSystem: rawDevice.os,
      osVersion: rawDevice.osVersion,
      appVersion: appVersion,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    model,
    manufacturer,
    operatingSystem,
    osVersion,
    appVersion,
    createdAt,
    updatedAt,
  ];
}
