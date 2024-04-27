import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:teamsyncai/model/user_model.dart';
import 'package:teamsyncai/services/userapiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [];
  String _invitationStatus = '';
  String? _userEmail; // Changed from _userId to _userEmail

  List<User> get users => _users;
  String get invitationStatus => _invitationStatus;
  String? get userEmail => _userEmail; // Changed from userId to userEmail

  Future<User> createUser(String username, String email, String numTel, String password, String specialty, File? cvFile) async {
    try {
      final User newUser = await UserApiService.createUser(username, email, numTel, password, specialty, cvFile);
      return newUser;
    } catch (e) {
      print('Failed to create user: $e');
      throw Exception('Failed to create user');
    }
  }

  Future<User> authenticateUser(String email, String password) async {
    try {
      final User user = await UserApiService.authenticateUser(email, password);

      // Save user email locally
      _userEmail = user.email; // Assuming 'email' is a field in your User model
      saveUserDetailsLocally(); // Save user details

      notifyListeners(); 
      return user;
    } catch (e) {
      print('Failed to authenticate user: $e');
      throw Exception('Failed to authenticate user');
    }
  }
    Future<String?> getUserEmail() async {
    return _userEmail;
  }

  void saveUserDetailsLocally() async {
    // Save user details to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', _userEmail ?? ''); // Save user email

    // Notify listeners if needed
    notifyListeners();
  }

  Future<User> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEmail = prefs.getString('userEmail') ?? '';

    // Fetch user profile using the stored userEmail
    return UserApiService.fetchUserProfileByEmail(userEmail);
  }

 
}