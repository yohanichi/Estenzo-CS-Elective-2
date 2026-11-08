import 'package:flutter/material.dart';

// The InheritedWidget
class ThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

// Stateful wrapper
class ThemeManager extends StatefulWidget {
  final Widget child;

  const ThemeManager({super.key, required this.child});

  @override
  State<ThemeManager> createState() => _ThemeManagerState();
}

class _ThemeManagerState extends State<ThemeManager> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: widget.child,
    );
  }
}

// Usage in a widget
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
