import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: const EmailRepository(),
      child: const MaterialApp(
        title: 'Example',
        home: RegisterPage(),
      ),
    );
  }
}
