import 'package:cs_elective_2/models/profile.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName;
  Profile profile;

  // constructor with default value for userName
  UserProvider({this.userName = 'Guest', Profile? profile})
    : profile =
          profile ??
          Profile(
            username: '',
            email: '',
            firstName: '',
            lastName: '',
            bio: '',
          );

  // can be sync or async type of function
  void updateUserName({required String newName}) {
    userName = newName;
    notifyListeners();
  }

  void updateProfile({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String bio,
  }) {
    profile.username = username;
    profile.email = email;
    profile.firstName = firstName;
    profile.lastName = lastName;
    profile.bio = bio;

    // Keep the simple state in sync
    userName = username;

    notifyListeners();
  }
}
