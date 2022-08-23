import 'package:async_forms/async_forms.dart';
import 'package:regexpattern/regexpattern.dart';

import '../../../../src.dart';

const _kEmailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

class EmailValidator
    extends AsyncFormInputValidator<Email, String, EmailValidationError> {
  const EmailValidator({
    required EmailRepository emailRepository,
  }) : _emailRepository = emailRepository;

  final EmailRepository _emailRepository;

  @override
  Future<EmailValidationError?> validate(Email input) async {
    if (input.required && input.value.isEmpty) {
      return const EmailValidationError.required();
    }

    final validFormat = RegVal.hasMatch(
      input.value,
      _kEmailPattern,
    );
    if (!validFormat) {
      return const EmailValidationError.invalidFormat();
    }

    final alreadyExist = await _emailRepository.findByAddress(input.value);
    if (alreadyExist) {
      return const EmailValidationError.alreadyExists();
    }

    return null;
  }
}
