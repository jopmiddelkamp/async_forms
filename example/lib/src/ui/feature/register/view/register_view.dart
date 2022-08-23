import 'package:async_forms/async_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../src.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _FormStatusText(),
            SizedBox(height: 16),
            _AmountTextField(),
            SizedBox(height: 16),
            _EmailTextField(),
          ],
        ),
      ),
    );
  }
}

class _FormStatusText extends StatelessWidget {
  const _FormStatusText();

  @override
  Widget build(BuildContext context) {
    final status = context.select<RegisterCubit, AsyncFormStatus>(
      (c) => c.state.status,
    );
    return Text.rich(TextSpan(
      children: [
        const TextSpan(
          text: 'Form status: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: status.name,
          style: TextStyle(
            color: status == AsyncFormStatus.valid
                ? Colors.green
                : status == AsyncFormStatus.invalid
                    ? Colors.red
                    : Colors.blue,
          ),
        ),
      ],
    ));
  }
}

class _AmountTextField extends StatefulWidget {
  const _AmountTextField();

  @override
  State<_AmountTextField> createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<_AmountTextField> {
  late FocusNode textFocusNode;
  late TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    textFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final amount = context.select<RegisterCubit, Amount>(
      (c) => c.state.amount,
    );
    if (!textFocusNode.hasFocus) {
      textController.text = amount.value;
    }
    print('amount: $amount');
    return FormLabel(
      label: const Text('Amount'),
      child: TextFormField(
        controller: textController,
        focusNode: textFocusNode,
        onChanged: (value) {
          cubit.amountChanged(value);
        },
        decoration: InputDecoration(
          hintText: "Amount in \$",
          errorText: amount.error?.map(
            outOfRange: (value) =>
                "Amount must be between ${value.min} and ${value.max}",
            parsing: (_) => "Amount must be a number",
            required: (_) => "Amount is required",
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
      ),
    );
  }
}

class _EmailTextField extends StatefulWidget {
  const _EmailTextField();

  @override
  State<_EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<_EmailTextField> {
  late FocusNode textFocusNode;
  late TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    textFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final email = context.select<RegisterCubit, Email>(
      (c) => c.state.email,
    );
    if (!textFocusNode.hasFocus) {
      textController.text = email.value;
    }
    print('email: $email');
    return FormLabel(
      label: const Text('Email'),
      child: TextFormField(
        controller: textController,
        focusNode: textFocusNode,
        onChanged: (value) {
          cubit.emailChanged(value);
        },
        decoration: InputDecoration(
          hintText: "Enter your email",
          helperText: email.validating ? 'Validating...' : null,
          errorText: !email.validating
              ? email.error?.map(
                  invalidFormat: (_) => "Invalid email format",
                  alreadyExists: (_) => "Email already exists",
                  required: (_) => "Email is required",
                )
              : null,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
