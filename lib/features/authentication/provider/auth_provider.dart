// lib/features/authentication/provider/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery_app/features/authentication/service/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _isLoading = true;
    notifyListeners();

    // Check for existing Firebase user
    _user = _authService.currentUser;

    // If we find a user, we're done
    if (_user != null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Try to get saved auth credentials
    final prefs = await SharedPreferences.getInstance();
    final hasLoggedInBefore = prefs.getBool('isLoggedIn') ?? false;

    // If user had logged in before, try to silently sign them in
    if (hasLoggedInBefore) {
      // For security reasons, we don't store the password locally
      // Rely on Firebase Auth persistence instead
      _user = _authService.currentUser;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_user != null) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    try {
      _user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_user != null) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _user = await _authService.signInwithGoogle();

      if (_user != null) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;

    // Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    notifyListeners();
  }
}
