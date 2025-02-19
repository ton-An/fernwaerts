// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_calendar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyCalendarState {
  DateTime get focusedMonth => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyCalendarStateCopyWith<MonthlyCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyCalendarStateCopyWith<$Res> {
  factory $MonthlyCalendarStateCopyWith(MonthlyCalendarState value,
          $Res Function(MonthlyCalendarState) then) =
      _$MonthlyCalendarStateCopyWithImpl<$Res, MonthlyCalendarState>;
  @useResult
  $Res call({DateTime focusedMonth});
}

/// @nodoc
class _$MonthlyCalendarStateCopyWithImpl<$Res,
        $Val extends MonthlyCalendarState>
    implements $MonthlyCalendarStateCopyWith<$Res> {
  _$MonthlyCalendarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusedMonth = null,
  }) {
    return _then(_value.copyWith(
      focusedMonth: null == focusedMonth
          ? _value.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyCalendarStateImplCopyWith<$Res>
    implements $MonthlyCalendarStateCopyWith<$Res> {
  factory _$$MonthlyCalendarStateImplCopyWith(_$MonthlyCalendarStateImpl value,
          $Res Function(_$MonthlyCalendarStateImpl) then) =
      __$$MonthlyCalendarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime focusedMonth});
}

/// @nodoc
class __$$MonthlyCalendarStateImplCopyWithImpl<$Res>
    extends _$MonthlyCalendarStateCopyWithImpl<$Res, _$MonthlyCalendarStateImpl>
    implements _$$MonthlyCalendarStateImplCopyWith<$Res> {
  __$$MonthlyCalendarStateImplCopyWithImpl(_$MonthlyCalendarStateImpl _value,
      $Res Function(_$MonthlyCalendarStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusedMonth = null,
  }) {
    return _then(_$MonthlyCalendarStateImpl(
      focusedMonth: null == focusedMonth
          ? _value.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$MonthlyCalendarStateImpl implements _MonthlyCalendarState {
  const _$MonthlyCalendarStateImpl({required this.focusedMonth});

  @override
  final DateTime focusedMonth;

  @override
  String toString() {
    return 'MonthlyCalendarState(focusedMonth: $focusedMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyCalendarStateImpl &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, focusedMonth);

  /// Create a copy of MonthlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyCalendarStateImplCopyWith<_$MonthlyCalendarStateImpl>
      get copyWith =>
          __$$MonthlyCalendarStateImplCopyWithImpl<_$MonthlyCalendarStateImpl>(
              this, _$identity);
}

abstract class _MonthlyCalendarState implements MonthlyCalendarState {
  const factory _MonthlyCalendarState({required final DateTime focusedMonth}) =
      _$MonthlyCalendarStateImpl;

  @override
  DateTime get focusedMonth;

  /// Create a copy of MonthlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyCalendarStateImplCopyWith<_$MonthlyCalendarStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
