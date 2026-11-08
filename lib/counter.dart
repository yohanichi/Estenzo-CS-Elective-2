import 'package:cs_elective_2/components/middle_widget.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState(); // 1
}

class _CounterPageState extends State<CounterPage> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    debugPrint('initState - runs ONCE, when State object is created');
    // good place for: subscriptions, controllers, one-time setup
  }

  void _incrementCounter() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build - runs on EVERY rebuild');
    return Scaffold(
      appBar: AppBar(automaticallyImplyActions: true),
      body: Center(
        child: Column(
          children: [
            Text('Tap the button to toggle the theme'),
            SizedBox(height: 16),
            MiddleWidget(),
            SizedBox(height: 16),
            Text('Count: $count'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('dispose - runs ONCE, when State is removed forever');
    // cleanup: cancel subscriptions, dispose controllers
    super.dispose();
  }
}
