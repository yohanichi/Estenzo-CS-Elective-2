import 'package:flutter/material.dart';
import '../pages/future.dart';
import '../pages/stream.dart';

class AsyncDemo extends StatelessWidget {
  const AsyncDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Async in Flutter'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FutureBuilder'),
              Tab(text: 'StreamBuilder'),
            ],
          ),
        ),
        body: const TabBarView(children: [FuturePage(), StreamPage()]),
      ),
    );
  }
}
