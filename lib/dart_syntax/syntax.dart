import 'package:flutter/material.dart';

class SyntaxWidget extends StatelessWidget {
  const SyntaxWidget({super.key, this.name2});

  String? getName() {
    return 'Louise';
  }

  final String? name2;
  final String name = 'Louise';
  final int age = 25;
  final double gpa = 3.5;
  final bool isEnrolled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Variable Example')),
      body: Column(
        children: [
          Text(name2 ?? 'Unknown'),
          Text(name),
          Text('Age: $age'),
          Text('GPA: $gpa'),
          Text('Enrolled: $isEnrolled'),
        ],
      ),
    );
  }
}
