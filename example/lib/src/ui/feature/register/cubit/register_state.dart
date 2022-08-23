import 'package:async_forms/async_forms.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../src.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  factory RegisterState({
    @Default(AsyncFormStatus.pure) AsyncFormStatus status,
    @Default(Amount.pure(max: 100)) Amount amount,
    @Default(Email.pure()) Email email,
  }) = _RegisterState;
}
