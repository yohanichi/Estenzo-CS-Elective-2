import 'package:flutter/material.dart';
import 'package:cs_elective_2/riverpod/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderHome extends ConsumerWidget {
  const ProviderHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userProvider = Provider.of<UserProvider>(context);
    // final profile = userProvider.profile;

    final user = ref.watch(userProvider);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              // context.watch<UserProvider>().userName,
              user.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [_buildLabel('Email'), _buildValue(user.email)],
                ),
                TableRow(
                  children: [
                    _buildLabel('First Name'),
                    _buildValue(user.firstName),
                  ],
                ),
                TableRow(
                  children: [
                    _buildLabel('Last Name'),
                    _buildValue(user.lastName),
                  ],
                ),
                TableRow(children: [_buildLabel('Bio'), _buildValue(user.bio)]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildValue(String value) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(value));
  }
}
