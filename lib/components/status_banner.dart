import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  final bool isDone;
  final int count;
  const StatusBanner({super.key, required this.isDone, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDone ? Colors.green.shade100 : Colors.amber.shade100,
      padding: const EdgeInsets.all(12),
      child: Text(
        isDone
            ? 'Stream finished ($count items)'
            : 'Live... received $count so far',
      ),
    );
  }
}
