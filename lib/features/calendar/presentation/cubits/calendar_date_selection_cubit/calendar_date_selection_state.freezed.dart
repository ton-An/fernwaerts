// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_date_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CalendarDaySelected {
  DateTime get selectedDate => throw _privateConstructorUsedError;

  /// Create a copy of CalendarDaySelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarDaySelectedCopyWith<CalendarDaySelected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarDaySelectedCopyWith<$Res> {
  factory $CalendarDaySelectedCopyWith(
    CalendarDaySelected value,
    $Res Function(CalendarDaySelected) then,
  ) = _$CalendarDaySelectedCopyWithImpl<$Res, CalendarDaySelected>;
  @useResult
  $Res call({DateTime selectedDate});
}

/// @nodoc
class _$CalendarDaySelectedCopyWithImpl<$Res, $Val extends CalendarDaySelected>
    implements $CalendarDaySelectedCopyWith<$Res> {
  _$CalendarDaySelectedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarDaySelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedDate = null}) {
    return _then(
      _value.copyWith(
            selectedDate:
                null == selectedDate
                    ? _value.selectedDate
                    : selectedDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CalendarDaySelectedImplCopyWith<$Res>
    implements $CalendarDaySelectedCopyWith<$Res> {
  factory _$$CalendarDaySelectedImplCopyWith(
    _$CalendarDaySelectedImpl value,
    $Res Function(_$CalendarDaySelectedImpl) then,
  ) = __$$CalendarDaySelectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime selectedDate});
}

/// @nodoc
class __$$CalendarDaySelectedImplCopyWithImpl<$Res>
    extends _$CalendarDaySelectedCopyWithImpl<$Res, _$CalendarDaySelectedImpl>
    implements _$$CalendarDaySelectedImplCopyWith<$Res> {
  __$$CalendarDaySelectedImplCopyWithImpl(
    _$CalendarDaySelectedImpl _value,
    $Res Function(_$CalendarDaySelectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CalendarDaySelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedDate = null}) {
    return _then(
      _$CalendarDaySelectedImpl(
        selectedDate:
            null == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$CalendarDaySelectedImpl implements _CalendarDaySelected {
  const _$CalendarDaySelectedImpl({required this.selectedDate});

  @override
  final DateTime selectedDate;

  @override
  String toString() {
    return 'CalendarDaySelected(selectedDate: $selectedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarDaySelectedImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedDate);

  /// Create a copy of CalendarDaySelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarDaySelectedImplCopyWith<_$CalendarDaySelectedImpl> get copyWith =>
      __$$CalendarDaySelectedImplCopyWithImpl<_$CalendarDaySelectedImpl>(
        this,
        _$identity,
      );
}

abstract class _CalendarDaySelected implements CalendarDaySelected {
  const factory _CalendarDaySelected({required final DateTime selectedDate}) =
      _$CalendarDaySelectedImpl;

  @override
  DateTime get selectedDate;

  /// Create a copy of CalendarDaySelected
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarDaySelectedImplCopyWith<_$CalendarDaySelectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CalendarCustomRangeSelected {
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of CalendarCustomRangeSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarCustomRangeSelectedCopyWith<CalendarCustomRangeSelected>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarCustomRangeSelectedCopyWith<$Res> {
  factory $CalendarCustomRangeSelectedCopyWith(
    CalendarCustomRangeSelected value,
    $Res Function(CalendarCustomRangeSelected) then,
  ) =
      _$CalendarCustomRangeSelectedCopyWithImpl<
        $Res,
        CalendarCustomRangeSelected
      >;
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class _$CalendarCustomRangeSelectedCopyWithImpl<
  $Res,
  $Val extends CalendarCustomRangeSelected
>
    implements $CalendarCustomRangeSelectedCopyWith<$Res> {
  _$CalendarCustomRangeSelectedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarCustomRangeSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _value.copyWith(
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CalendarCustomRangeSelectedImplCopyWith<$Res>
    implements $CalendarCustomRangeSelectedCopyWith<$Res> {
  factory _$$CalendarCustomRangeSelectedImplCopyWith(
    _$CalendarCustomRangeSelectedImpl value,
    $Res Function(_$CalendarCustomRangeSelectedImpl) then,
  ) = __$$CalendarCustomRangeSelectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class __$$CalendarCustomRangeSelectedImplCopyWithImpl<$Res>
    extends
        _$CalendarCustomRangeSelectedCopyWithImpl<
          $Res,
          _$CalendarCustomRangeSelectedImpl
        >
    implements _$$CalendarCustomRangeSelectedImplCopyWith<$Res> {
  __$$CalendarCustomRangeSelectedImplCopyWithImpl(
    _$CalendarCustomRangeSelectedImpl _value,
    $Res Function(_$CalendarCustomRangeSelectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CalendarCustomRangeSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _$CalendarCustomRangeSelectedImpl(
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$CalendarCustomRangeSelectedImpl
    implements _CalendarCustomRangeSelected {
  const _$CalendarCustomRangeSelectedImpl({
    required this.startDate,
    required this.endDate,
  });

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'CalendarCustomRangeSelected(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarCustomRangeSelectedImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of CalendarCustomRangeSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarCustomRangeSelectedImplCopyWith<_$CalendarCustomRangeSelectedImpl>
  get copyWith => __$$CalendarCustomRangeSelectedImplCopyWithImpl<
    _$CalendarCustomRangeSelectedImpl
  >(this, _$identity);
}

abstract class _CalendarCustomRangeSelected
    implements CalendarCustomRangeSelected {
  const factory _CalendarCustomRangeSelected({
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) = _$CalendarCustomRangeSelectedImpl;

  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of CalendarCustomRangeSelected
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarCustomRangeSelectedImplCopyWith<_$CalendarCustomRangeSelectedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CalendarWeekSelected {
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of CalendarWeekSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarWeekSelectedCopyWith<CalendarWeekSelected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarWeekSelectedCopyWith<$Res> {
  factory $CalendarWeekSelectedCopyWith(
    CalendarWeekSelected value,
    $Res Function(CalendarWeekSelected) then,
  ) = _$CalendarWeekSelectedCopyWithImpl<$Res, CalendarWeekSelected>;
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class _$CalendarWeekSelectedCopyWithImpl<
  $Res,
  $Val extends CalendarWeekSelected
>
    implements $CalendarWeekSelectedCopyWith<$Res> {
  _$CalendarWeekSelectedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarWeekSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _value.copyWith(
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CalendarWeekSelectedImplCopyWith<$Res>
    implements $CalendarWeekSelectedCopyWith<$Res> {
  factory _$$CalendarWeekSelectedImplCopyWith(
    _$CalendarWeekSelectedImpl value,
    $Res Function(_$CalendarWeekSelectedImpl) then,
  ) = __$$CalendarWeekSelectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class __$$CalendarWeekSelectedImplCopyWithImpl<$Res>
    extends _$CalendarWeekSelectedCopyWithImpl<$Res, _$CalendarWeekSelectedImpl>
    implements _$$CalendarWeekSelectedImplCopyWith<$Res> {
  __$$CalendarWeekSelectedImplCopyWithImpl(
    _$CalendarWeekSelectedImpl _value,
    $Res Function(_$CalendarWeekSelectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CalendarWeekSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _$CalendarWeekSelectedImpl(
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$CalendarWeekSelectedImpl implements _CalendarWeekSelected {
  const _$CalendarWeekSelectedImpl({
    required this.startDate,
    required this.endDate,
  });

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'CalendarWeekSelected(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarWeekSelectedImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of CalendarWeekSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarWeekSelectedImplCopyWith<_$CalendarWeekSelectedImpl>
  get copyWith =>
      __$$CalendarWeekSelectedImplCopyWithImpl<_$CalendarWeekSelectedImpl>(
        this,
        _$identity,
      );
}

abstract class _CalendarWeekSelected implements CalendarWeekSelected {
  const factory _CalendarWeekSelected({
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) = _$CalendarWeekSelectedImpl;

  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of CalendarWeekSelected
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarWeekSelectedImplCopyWith<_$CalendarWeekSelectedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CalendarMonthSelected {
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of CalendarMonthSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarMonthSelectedCopyWith<CalendarMonthSelected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarMonthSelectedCopyWith<$Res> {
  factory $CalendarMonthSelectedCopyWith(
    CalendarMonthSelected value,
    $Res Function(CalendarMonthSelected) then,
  ) = _$CalendarMonthSelectedCopyWithImpl<$Res, CalendarMonthSelected>;
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class _$CalendarMonthSelectedCopyWithImpl<
  $Res,
  $Val extends CalendarMonthSelected
>
    implements $CalendarMonthSelectedCopyWith<$Res> {
  _$CalendarMonthSelectedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarMonthSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _value.copyWith(
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CalendarMonthSelectedImplCopyWith<$Res>
    implements $CalendarMonthSelectedCopyWith<$Res> {
  factory _$$CalendarMonthSelectedImplCopyWith(
    _$CalendarMonthSelectedImpl value,
    $Res Function(_$CalendarMonthSelectedImpl) then,
  ) = __$$CalendarMonthSelectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class __$$CalendarMonthSelectedImplCopyWithImpl<$Res>
    extends
        _$CalendarMonthSelectedCopyWithImpl<$Res, _$CalendarMonthSelectedImpl>
    implements _$$CalendarMonthSelectedImplCopyWith<$Res> {
  __$$CalendarMonthSelectedImplCopyWithImpl(
    _$CalendarMonthSelectedImpl _value,
    $Res Function(_$CalendarMonthSelectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CalendarMonthSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _$CalendarMonthSelectedImpl(
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$CalendarMonthSelectedImpl implements _CalendarMonthSelected {
  const _$CalendarMonthSelectedImpl({
    required this.startDate,
    required this.endDate,
  });

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'CalendarMonthSelected(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarMonthSelectedImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of CalendarMonthSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarMonthSelectedImplCopyWith<_$CalendarMonthSelectedImpl>
  get copyWith =>
      __$$CalendarMonthSelectedImplCopyWithImpl<_$CalendarMonthSelectedImpl>(
        this,
        _$identity,
      );
}

abstract class _CalendarMonthSelected implements CalendarMonthSelected {
  const factory _CalendarMonthSelected({
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) = _$CalendarMonthSelectedImpl;

  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of CalendarMonthSelected
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarMonthSelectedImplCopyWith<_$CalendarMonthSelectedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CalendarYearSelected {
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of CalendarYearSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarYearSelectedCopyWith<CalendarYearSelected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarYearSelectedCopyWith<$Res> {
  factory $CalendarYearSelectedCopyWith(
    CalendarYearSelected value,
    $Res Function(CalendarYearSelected) then,
  ) = _$CalendarYearSelectedCopyWithImpl<$Res, CalendarYearSelected>;
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class _$CalendarYearSelectedCopyWithImpl<
  $Res,
  $Val extends CalendarYearSelected
>
    implements $CalendarYearSelectedCopyWith<$Res> {
  _$CalendarYearSelectedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarYearSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _value.copyWith(
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CalendarYearSelectedImplCopyWith<$Res>
    implements $CalendarYearSelectedCopyWith<$Res> {
  factory _$$CalendarYearSelectedImplCopyWith(
    _$CalendarYearSelectedImpl value,
    $Res Function(_$CalendarYearSelectedImpl) then,
  ) = __$$CalendarYearSelectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class __$$CalendarYearSelectedImplCopyWithImpl<$Res>
    extends _$CalendarYearSelectedCopyWithImpl<$Res, _$CalendarYearSelectedImpl>
    implements _$$CalendarYearSelectedImplCopyWith<$Res> {
  __$$CalendarYearSelectedImplCopyWithImpl(
    _$CalendarYearSelectedImpl _value,
    $Res Function(_$CalendarYearSelectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CalendarYearSelected
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = freezed, Object? endDate = freezed}) {
    return _then(
      _$CalendarYearSelectedImpl(
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$CalendarYearSelectedImpl implements _CalendarYearSelected {
  const _$CalendarYearSelectedImpl({
    required this.startDate,
    required this.endDate,
  });

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'CalendarYearSelected(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarYearSelectedImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of CalendarYearSelected
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarYearSelectedImplCopyWith<_$CalendarYearSelectedImpl>
  get copyWith =>
      __$$CalendarYearSelectedImplCopyWithImpl<_$CalendarYearSelectedImpl>(
        this,
        _$identity,
      );
}

abstract class _CalendarYearSelected implements CalendarYearSelected {
  const factory _CalendarYearSelected({
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) = _$CalendarYearSelectedImpl;

  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of CalendarYearSelected
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarYearSelectedImplCopyWith<_$CalendarYearSelectedImpl>
  get copyWith => throw _privateConstructorUsedError;
}
