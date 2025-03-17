// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yearly_calendar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$YearlyCalendarState {
  DateTime get focusedYear => throw _privateConstructorUsedError;

  /// Create a copy of YearlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YearlyCalendarStateCopyWith<YearlyCalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YearlyCalendarStateCopyWith<$Res> {
  factory $YearlyCalendarStateCopyWith(
    YearlyCalendarState value,
    $Res Function(YearlyCalendarState) then,
  ) = _$YearlyCalendarStateCopyWithImpl<$Res, YearlyCalendarState>;
  @useResult
  $Res call({DateTime focusedYear});
}

/// @nodoc
class _$YearlyCalendarStateCopyWithImpl<$Res, $Val extends YearlyCalendarState>
    implements $YearlyCalendarStateCopyWith<$Res> {
  _$YearlyCalendarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YearlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? focusedYear = null}) {
    return _then(
      _value.copyWith(
            focusedYear:
                null == focusedYear
                    ? _value.focusedYear
                    : focusedYear // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$YearlyCalendarStateImplCopyWith<$Res>
    implements $YearlyCalendarStateCopyWith<$Res> {
  factory _$$YearlyCalendarStateImplCopyWith(
    _$YearlyCalendarStateImpl value,
    $Res Function(_$YearlyCalendarStateImpl) then,
  ) = __$$YearlyCalendarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime focusedYear});
}

/// @nodoc
class __$$YearlyCalendarStateImplCopyWithImpl<$Res>
    extends _$YearlyCalendarStateCopyWithImpl<$Res, _$YearlyCalendarStateImpl>
    implements _$$YearlyCalendarStateImplCopyWith<$Res> {
  __$$YearlyCalendarStateImplCopyWithImpl(
    _$YearlyCalendarStateImpl _value,
    $Res Function(_$YearlyCalendarStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of YearlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? focusedYear = null}) {
    return _then(
      _$YearlyCalendarStateImpl(
        focusedYear:
            null == focusedYear
                ? _value.focusedYear
                : focusedYear // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$YearlyCalendarStateImpl implements _YearlyCalendarState {
  const _$YearlyCalendarStateImpl({required this.focusedYear});

  @override
  final DateTime focusedYear;

  @override
  String toString() {
    return 'YearlyCalendarState(focusedYear: $focusedYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YearlyCalendarStateImpl &&
            (identical(other.focusedYear, focusedYear) ||
                other.focusedYear == focusedYear));
  }

  @override
  int get hashCode => Object.hash(runtimeType, focusedYear);

  /// Create a copy of YearlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YearlyCalendarStateImplCopyWith<_$YearlyCalendarStateImpl> get copyWith =>
      __$$YearlyCalendarStateImplCopyWithImpl<_$YearlyCalendarStateImpl>(
        this,
        _$identity,
      );
}

abstract class _YearlyCalendarState implements YearlyCalendarState {
  const factory _YearlyCalendarState({required final DateTime focusedYear}) =
      _$YearlyCalendarStateImpl;

  @override
  DateTime get focusedYear;

  /// Create a copy of YearlyCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YearlyCalendarStateImplCopyWith<_$YearlyCalendarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
