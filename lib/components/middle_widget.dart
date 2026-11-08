import 'package:cs_elective_2/pages/inherited_widget.dart';
import 'package:flutter/material.dart';

class MiddleWidget extends StatelessWidget {
  const MiddleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemedButton();
  }
}

class ThemedButton extends StatelessWidget {
  const ThemedButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);

    return ElevatedButton(
      onPressed: themeProvider?.toggleTheme,
      child: Text(
        'Current: ${themeProvider?.themeMode == ThemeMode.light ? "Light" : "Dark"}',
      ),
    );
  }
}
