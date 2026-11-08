import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';
import '../components/status_banner.dart';
import '../components/todo_tile.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  final _api = ApiService();
  late Stream<List<Todo>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _api.todoStream();
  }

  void _restart() {
    setState(() {
      _stream = _api.todoStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        child: const Icon(Icons.replay),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          final isDone = snapshot.connectionState == ConnectionState.done;
          return Column(
            children: [
              StatusBanner(isDone: isDone, count: todos.length),
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (_, i) => TodoTile(todo: todos[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
