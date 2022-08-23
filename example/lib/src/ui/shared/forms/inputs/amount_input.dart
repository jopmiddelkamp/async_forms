//import 'package:formz/formz.dart';
import 'package:async_forms/async_forms.dart';
import 'package:decimal/decimal.dart';

import '../../../../src.dart';

const _kDefaultRequired = true;
const _kDefaultMin = 0.0;
const _kDefaultMax = double.maxFinite;

class Amount extends AsyncFormInput<String, AmountValidationError> {
  const Amount(
    String value, {
    bool pure = true,
    AmountValidationError? error,
    bool validating = false,
    this.required = _kDefaultRequired,
    this.min = _kDefaultMin,
    this.max = _kDefaultMax,
  }) : super(
          value,
          pure: pure,
          error: error,
          validating: validating,
        );

  const Amount.pure({
    bool required = _kDefaultRequired,
    double min = _kDefaultMin,
    double max = _kDefaultMax,
  }) : this(
          '',
          pure: true,
          required: required,
          min: min,
          max: max,
          validating: false,
        );

  const Amount.dirty(
    String value, {
    bool required = _kDefaultRequired,
    double min = _kDefaultMin,
    double max = _kDefaultMax,
    AmountValidationError? error,
    bool validating = false,
  }) : this(
          value,
          pure: false,
          required: _kDefaultRequired,
          min: _kDefaultMin,
          max: _kDefaultMax,
          error: error,
          validating: validating,
        );

  final bool required;
  final double min;
  final double max;

  Amount copyWith({
    String? value,
    AmountValidationError? error,
    bool? validating,
    bool? required,
    double? min,
    double? max,
  }) {
    final newValue = value ?? this.value;
    return Amount(
      newValue,
      pure: (pure && newValue.isEmpty),
      error: error ?? this.error,
      validating: validating ?? this.validating,
      required: required ?? this.required,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  Amount copyWithExceptError({
    String? value,
    bool? validating,
    bool? required,
    double? min,
    double? max,
  }) {
    final newValue = value ?? this.value;
    return Amount(
      newValue,
      pure: (pure && newValue.isEmpty),
      validating: validating ?? this.validating,
      required: required ?? this.required,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  double toDouble() => double.parse(value);

  Decimal toDecimal() => Decimal.parse(value);

  double? toDoubleOrNull() => double.tryParse(value);

  Decimal? toDecimalOrNull() => Decimal.tryParse(value);

  Decimal toDecimalOr(Decimal or) => Decimal.tryParse(value) ?? or;

  Decimal toDecimalOrZero() => toDecimalOr(Decimal.zero);

  @override
  String toString() {
    return '$runtimeType(pure: $pure, value: \'$value\', error: ${error.runtimeType}, validating: $validating, required: $required, min: $min, max: $max)';
  }

  @override
  int get hashCode =>
      value.hashCode ^
      pure.hashCode ^
      error.hashCode ^
      validating.hashCode ^
      required.hashCode ^
      min.hashCode ^
      max.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is Amount &&
        other.value == value &&
        other.pure == pure &&
        other.error == error &&
        other.validating == validating &&
        other.required == required &&
        other.min == min &&
        other.max == max;
  }
}
