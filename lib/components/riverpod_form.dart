import 'package:cs_elective_2/riverpod/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodForm extends ConsumerStatefulWidget {
  const RiverpodForm({super.key});

  @override
  ConsumerState<RiverpodForm> createState() => _RiverpodFormState();
}

class _RiverpodFormState extends ConsumerState<RiverpodForm> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ref
        .read(userProvider.notifier)
        .updateProfile(
          username: _userNameController.text,
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          bio: _bioController.text,
        );

    _userNameController.clear();
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _bioController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when userName changes
    final userName = ref.watch(userProvider.select((u) => u.userName));

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [const Text('Username:'), Text(userName)]),
              const SizedBox(height: 20),
              TextField(
                controller: _userNameController,
                onChanged: (value) {
                  ref
                      .read(userProvider.notifier)
                      .updateUserName(newName: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Enter username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Enter Bio',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _saveProfile,
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
