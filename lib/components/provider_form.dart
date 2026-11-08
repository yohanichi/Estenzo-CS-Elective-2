import 'package:cs_elective_2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderForm extends StatefulWidget {
  const ProviderForm({super.key});

  @override
  State<ProviderForm> createState() => _ProviderFormState();
}

class _ProviderFormState extends State<ProviderForm> {
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
    context.read<UserProvider>().updateProfile(
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('Username:'),
                  Text(context.watch<UserProvider>().userName),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _userNameController,
                onChanged: (value) {
                  context.read<UserProvider>().updateUserName(newName: value);
                },
                decoration: InputDecoration(
                  labelText: 'Enter username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Enter First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _bioController,
                decoration: InputDecoration(
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
        label: Text('Save'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
