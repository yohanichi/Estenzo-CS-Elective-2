import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: todo.completed ? Colors.green : null,
      ),
      title: Text(todo.title),
    );
  }
}
