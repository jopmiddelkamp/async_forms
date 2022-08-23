import 'package:async_forms/async_forms.dart';

import '../../../../src.dart';

const _kDefaultRequired = true;

class Email extends AsyncFormInput<String, EmailValidationError> {
  const Email(
    String value, {
    bool pure = true,
    EmailValidationError? error,
    bool validating = false,
    this.required = _kDefaultRequired,
  }) : super(
          value,
          pure: pure,
          error: error,
          validating: validating,
        );

  const Email.pure({
    bool required = _kDefaultRequired,
  }) : this(
          '',
          pure: true,
          required: required,
          validating: false,
        );

  const Email.dirty(
    String value, {
    bool required = _kDefaultRequired,
    EmailValidationError? error,
    bool validating = false,
  }) : this(
          value,
          pure: false,
          required: _kDefaultRequired,
          error: error,
          validating: validating,
        );

  final bool required;

  Email copyWith({
    String? value,
    EmailValidationError? error,
    bool? validating,
    bool? required,
  }) {
    final newValue = value ?? this.value;
    return Email(
      newValue,
      pure: (pure && newValue.isEmpty),
      error: error ?? this.error,
      validating: validating ?? this.validating,
      required: required ?? this.required,
    );
  }

  Email copyWithExceptError({
    String? value,
    bool? validating,
    bool? required,
  }) {
    final newValue = value ?? this.value;
    return Email(
      newValue,
      pure: (pure && newValue.isEmpty),
      validating: validating ?? this.validating,
      required: required ?? this.required,
    );
  }

  @override
  String toString() {
    return '$runtimeType(pure: $pure, value: \'$value\', error: ${error.runtimeType}, validating: $validating, required: $required)';
  }

  @override
  int get hashCode =>
      value.hashCode ^
      pure.hashCode ^
      error.hashCode ^
      validating.hashCode ^
      required.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Email &&
        other.value == value &&
        other.pure == pure &&
        other.error == error &&
        other.validating == validating &&
        other.required == required;
  }
}
