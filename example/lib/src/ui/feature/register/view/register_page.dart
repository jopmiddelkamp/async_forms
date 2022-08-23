import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(
        amountValidator: const AmountValidator(),
        emailValidator: EmailValidator(
          emailRepository: context.read(),
        ),
      ),
      child: const RegisterView(),
    );
  }
}
