// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'decennially_calendar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DecenniallyCalendarState {
  DateTime get startYear => throw _privateConstructorUsedError;
  DateTime get endYear => throw _privateConstructorUsedError;

  /// Create a copy of DecenniallyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DecenniallyCalendarStateCopyWith<DecenniallyCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecenniallyCalendarStateCopyWith<$Res> {
  factory $DecenniallyCalendarStateCopyWith(DecenniallyCalendarState value,
          $Res Function(DecenniallyCalendarState) then) =
      _$DecenniallyCalendarStateCopyWithImpl<$Res, DecenniallyCalendarState>;
  @useResult
  $Res call({DateTime startYear, DateTime endYear});
}

/// @nodoc
class _$DecenniallyCalendarStateCopyWithImpl<$Res,
        $Val extends DecenniallyCalendarState>
    implements $DecenniallyCalendarStateCopyWith<$Res> {
  _$DecenniallyCalendarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DecenniallyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startYear = null,
    Object? endYear = null,
  }) {
    return _then(_value.copyWith(
      startYear: null == startYear
          ? _value.startYear
          : startYear // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endYear: null == endYear
          ? _value.endYear
          : endYear // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DecenniallyCalendarStateImplCopyWith<$Res>
    implements $DecenniallyCalendarStateCopyWith<$Res> {
  factory _$$DecenniallyCalendarStateImplCopyWith(
          _$DecenniallyCalendarStateImpl value,
          $Res Function(_$DecenniallyCalendarStateImpl) then) =
      __$$DecenniallyCalendarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startYear, DateTime endYear});
}

/// @nodoc
class __$$DecenniallyCalendarStateImplCopyWithImpl<$Res>
    extends _$DecenniallyCalendarStateCopyWithImpl<$Res,
        _$DecenniallyCalendarStateImpl>
    implements _$$DecenniallyCalendarStateImplCopyWith<$Res> {
  __$$DecenniallyCalendarStateImplCopyWithImpl(
      _$DecenniallyCalendarStateImpl _value,
      $Res Function(_$DecenniallyCalendarStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DecenniallyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startYear = null,
    Object? endYear = null,
  }) {
    return _then(_$DecenniallyCalendarStateImpl(
      startYear: null == startYear
          ? _value.startYear
          : startYear // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endYear: null == endYear
          ? _value.endYear
          : endYear // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$DecenniallyCalendarStateImpl implements _DecenniallyCalendarState {
  const _$DecenniallyCalendarStateImpl(
      {required this.startYear, required this.endYear});

  @override
  final DateTime startYear;
  @override
  final DateTime endYear;

  @override
  String toString() {
    return 'DecenniallyCalendarState(startYear: $startYear, endYear: $endYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecenniallyCalendarStateImpl &&
            (identical(other.startYear, startYear) ||
                other.startYear == startYear) &&
            (identical(other.endYear, endYear) || other.endYear == endYear));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startYear, endYear);

  /// Create a copy of DecenniallyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DecenniallyCalendarStateImplCopyWith<_$DecenniallyCalendarStateImpl>
      get copyWith => __$$DecenniallyCalendarStateImplCopyWithImpl<
          _$DecenniallyCalendarStateImpl>(this, _$identity);
}

abstract class _DecenniallyCalendarState implements DecenniallyCalendarState {
  const factory _DecenniallyCalendarState(
      {required final DateTime startYear,
      required final DateTime endYear}) = _$DecenniallyCalendarStateImpl;

  @override
  DateTime get startYear;
  @override
  DateTime get endYear;

  /// Create a copy of DecenniallyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DecenniallyCalendarStateImplCopyWith<_$DecenniallyCalendarStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
