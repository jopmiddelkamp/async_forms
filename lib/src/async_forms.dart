// This package is a spin-off from the original `formz` package created by
// Very Good Ventures. Much of the code is copied from that package, but
// this package is designed to allow async validations.
// https://pub.dev/packages/formz
// https://github.com/VeryGoodOpenSource/formz

import 'dart:async';

import 'package:meta/meta.dart';

enum AsyncFormStatus {
  pure,
  valid,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
  submissionCanceled
}

const _validatedFormzStatuses = <AsyncFormStatus>{
  AsyncFormStatus.valid,
  AsyncFormStatus.submissionInProgress,
  AsyncFormStatus.submissionSuccess,
  AsyncFormStatus.submissionFailure,
  AsyncFormStatus.submissionCanceled,
};

extension AsyncFormStatusX on AsyncFormStatus {
  bool get isPure => this == AsyncFormStatus.pure;
  bool get isValid => this == AsyncFormStatus.valid;
  bool get isValidated => _validatedFormzStatuses.contains(this);
  bool get isInvalid => this == AsyncFormStatus.invalid;
  bool get isSubmissionInProgress =>
      this == AsyncFormStatus.submissionInProgress;
  bool get isSubmissionSuccess => this == AsyncFormStatus.submissionSuccess;
  bool get isSubmissionFailure => this == AsyncFormStatus.submissionFailure;
  bool get isSubmissionCanceled => this == AsyncFormStatus.submissionCanceled;
}

enum AsyncFormInputStatus {
  pure,
  valid,
  invalid,
}

abstract class AsyncFormInputStreamValidator<
    TInput extends AsyncFormInput<TValue, TError>,
    TValue,
    TError> extends AsyncFormInputValidator<TInput, TValue, TError> {
  AsyncFormInputStreamValidator({
    required Stream<TInput> inputStream,
    this.debounceDuration = const Duration(milliseconds: 200),
    required this.onValidated,
  }) {
    _inputSubscription = inputStream.distinct().listen(_inputUpdated);
  }

  void _inputUpdated(TInput input) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      debounceDuration,
      () async {
        final updatedInput = await validate(input);
        onValidated.call(updatedInput);
      },
    );
  }

  late StreamSubscription _inputSubscription;

  final Duration debounceDuration;
  final Function(TError? error) onValidated;

  Timer? _debounceTimer;

  @mustCallSuper
  void dispose() {
    _inputSubscription.cancel();
  }
}

abstract class AsyncFormInputValidator<
    TInput extends AsyncFormInput<TValue, TError>, TValue, TError> {
  const AsyncFormInputValidator();

  @protected
  Future<TError?> validate(TInput input);
}

const _kDefaultPure = true;
const _kDefaultValidating = false;

abstract class AsyncFormInput<TValue, TError> {
  const AsyncFormInput(
    this.value, {
    this.pure = _kDefaultPure,
    this.error,
    this.validating = _kDefaultValidating,
  });

  const AsyncFormInput.pure(TValue value) : this(value);

  const AsyncFormInput.dirty(
    TValue value, {
    TError? error,
    bool validating = _kDefaultValidating,
  }) : this(
          value,
          pure: false,
          error: error,
          validating: validating,
        );

  final TValue value;

  final bool pure;

  AsyncFormInputStatus get status =>
      valid ? AsyncFormInputStatus.valid : AsyncFormInputStatus.invalid;

  final TError? error;

  final bool validating;

  bool get valid => error == null;

  bool get invalid => !valid;

  @override
  int get hashCode => value.hashCode ^ pure.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AsyncFormInput<TValue, TError> &&
        other.value == value &&
        other.pure == pure;
  }

  @override
  String toString() => '$runtimeType($value, $pure)';
}

class AsyncForm {
  static AsyncFormStatus validate(
    List<AsyncFormInput> inputs,
  ) {
    return inputs.every((e) => e.pure)
        ? AsyncFormStatus.pure
        : inputs.any((e) => e.valid == false)
            ? AsyncFormStatus.invalid
            : AsyncFormStatus.valid;
  }
}
