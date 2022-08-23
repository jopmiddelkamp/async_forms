import 'package:async_forms/async_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required AmountValidator amountValidator,
    required EmailValidator emailValidator,
  })  : _amountValidator = amountValidator,
        _emailValidator = emailValidator,
        super(RegisterState());

  final AmountValidator _amountValidator;
  final EmailValidator _emailValidator;

  Future<void> amountChanged(String value) async {
    emit(state.copyWith(
      amount: state.amount.copyWithExceptError(
        value: value,
        validating: true,
      ),
    ));
    emit(state.copyWith(
      amount: state.amount.copyWith(
        error: await _amountValidator.validate(state.amount),
        validating: false,
      ),
    ));
    _updateFormState();
  }

  Future<void> emailChanged(String value) async {
    emit(state.copyWith(
      email: state.email.copyWithExceptError(
        value: value,
        validating: true,
      ),
    ));
    emit(state.copyWith(
      email: state.email.copyWith(
        error: await _emailValidator.validate(state.email),
        validating: false,
      ),
    ));
    _updateFormState();
  }

  void _updateFormState() {
    emit(state.copyWith(
      status: AsyncForm.validate([
        state.amount,
        state.email,
      ]),
    ));
  }
}
