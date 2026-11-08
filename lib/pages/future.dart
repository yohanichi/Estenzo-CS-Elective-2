import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import '../components/post_tile.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  final _api = ApiService();

  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchPosts();
  }

  void _reload() {
    setState(() {
      _future = _api.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _reload,
        child: const Icon(Icons.refresh),
      ),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (_, i) => PostTile(post: posts[i]),
          );
        },
      ),
    );
  }
}
