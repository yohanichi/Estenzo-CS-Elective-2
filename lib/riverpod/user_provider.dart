import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod prefers immutable state, so the fields live in a plain class.
class UserState {
  final String userName;
  final String email;
  final String firstName;
  final String lastName;
  final String bio;

  const UserState({
    this.userName = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.bio = '',
  });

  UserState copyWith({
    String? userName,
    String? email,
    String? firstName,
    String? lastName,
    String? bio,
  }) {
    return UserState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
    );
  }
}

// The Notifier holds the logic. There's no notifyListeners():
// assigning to `state` triggers the rebuild.
class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  void updateUserName({required String newName}) {
    state = state.copyWith(userName: newName);
  }

  void updateProfile({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String bio,
  }) {
    state = UserState(
      userName: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      bio: bio,
    );
  }
}

// This global provider is what widgets use to access the notifier.
final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
