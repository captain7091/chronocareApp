import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  String? _displayName;
  String? _email;
  String? _uid;

  String get displayName => _displayName ?? 'User';
  String get email => _email ?? '';
  String get uid => _uid ?? '';

  void setUser(User? user) {
    _displayName = user?.displayName;
    _email = user?.email;
    _uid = user?.uid;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setUser(FirebaseAuth.instance.currentUser);
  }

  void clearUser() {
    _displayName = null;
    _email = null;
    _uid = null;
    notifyListeners();
  }
} 