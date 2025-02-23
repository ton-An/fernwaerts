// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Activity {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  Coordinate get startCoordinate => throw _privateConstructorUsedError;
  Coordinate get endCoordinate => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      ActivityType type,
      Coordinate startCoordinate,
      Coordinate endCoordinate,
      double distance});

  $CoordinateCopyWith<$Res> get startCoordinate;
  $CoordinateCopyWith<$Res> get endCoordinate;
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? startCoordinate = null,
    Object? endCoordinate = null,
    Object? distance = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      startCoordinate: null == startCoordinate
          ? _value.startCoordinate
          : startCoordinate // ignore: cast_nullable_to_non_nullable
              as Coordinate,
      endCoordinate: null == endCoordinate
          ? _value.endCoordinate
          : endCoordinate // ignore: cast_nullable_to_non_nullable
              as Coordinate,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoordinateCopyWith<$Res> get startCoordinate {
    return $CoordinateCopyWith<$Res>(_value.startCoordinate, (value) {
      return _then(_value.copyWith(startCoordinate: value) as $Val);
    });
  }

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoordinateCopyWith<$Res> get endCoordinate {
    return $CoordinateCopyWith<$Res>(_value.endCoordinate, (value) {
      return _then(_value.copyWith(endCoordinate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
          _$ActivityImpl value, $Res Function(_$ActivityImpl) then) =
      __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      ActivityType type,
      Coordinate startCoordinate,
      Coordinate endCoordinate,
      double distance});

  @override
  $CoordinateCopyWith<$Res> get startCoordinate;
  @override
  $CoordinateCopyWith<$Res> get endCoordinate;
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
      _$ActivityImpl _value, $Res Function(_$ActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? startCoordinate = null,
    Object? endCoordinate = null,
    Object? distance = null,
  }) {
    return _then(_$ActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      startCoordinate: null == startCoordinate
          ? _value.startCoordinate
          : startCoordinate // ignore: cast_nullable_to_non_nullable
              as Coordinate,
      endCoordinate: null == endCoordinate
          ? _value.endCoordinate
          : endCoordinate // ignore: cast_nullable_to_non_nullable
              as Coordinate,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.type,
      required this.startCoordinate,
      required this.endCoordinate,
      required this.distance});

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final ActivityType type;
  @override
  final Coordinate startCoordinate;
  @override
  final Coordinate endCoordinate;
  @override
  final double distance;

  @override
  String toString() {
    return 'Activity(id: $id, startTime: $startTime, endTime: $endTime, type: $type, startCoordinate: $startCoordinate, endCoordinate: $endCoordinate, distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startCoordinate, startCoordinate) ||
                other.startCoordinate == startCoordinate) &&
            (identical(other.endCoordinate, endCoordinate) ||
                other.endCoordinate == endCoordinate) &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime, type,
      startCoordinate, endCoordinate, distance);

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);
}

abstract class _Activity implements Activity {
  const factory _Activity(
      {required final String id,
      required final DateTime startTime,
      required final DateTime endTime,
      required final ActivityType type,
      required final Coordinate startCoordinate,
      required final Coordinate endCoordinate,
      required final double distance}) = _$ActivityImpl;

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  ActivityType get type;
  @override
  Coordinate get startCoordinate;
  @override
  Coordinate get endCoordinate;
  @override
  double get distance;

  /// Create a copy of Activity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
