import 'package:async_forms/async_forms.dart';

import '../../../../src.dart';

class AmountValidator
    extends AsyncFormInputValidator<Amount, String, AmountValidationError> {
  const AmountValidator();

  @override
  Future<AmountValidationError?> validate(Amount input) async {
    if (input.required && input.value.isEmpty) {
      return const AmountValidationError.required();
    }
    final parsed = double.tryParse(input.value);
    if ((parsed == null || parsed.isNaN)) {
      return AmountValidationError.parsing(
        amount: input.value,
      );
    } else if (parsed < input.min || parsed > input.max) {
      return AmountValidationError.outOfRange(
        amount: input.value,
        min: input.min,
        max: input.max,
      );
    }
    return null;
  }
}
