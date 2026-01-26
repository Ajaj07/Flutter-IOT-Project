import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  static const String _userKey = 'current_user';
  static const String _isAuthenticatedKey = 'is_authenticated';

  AuthRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Check if user already exists (simulate database check)
    final existingUser = await getCurrentUser();
    if (existingUser != null && existingUser.email == email) {
      throw Exception('User already exists');
    }

    // Create new user
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.toLowerCase().trim(),
      name: name.trim(),
      password: _hashPassword(password),
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // Save user session
    await saveUserSession(user);
    return user;
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate email format
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Get current user (simulate database lookup)
    final currentUser = await getCurrentUser();
    
    if (currentUser == null) {
      throw Exception('User not found. Please sign up first.');
    }

    if (currentUser.email != email.toLowerCase().trim()) {
      throw Exception('Invalid email or password');
    }

    // Verify password (in real app, this would be against stored hash)
    if (currentUser.password != _hashPassword(password)) {
      throw Exception('Invalid email or password');
    }

    // Update last login
    final updatedUser = currentUser.copyWith(
      lastLoginAt: DateTime.now(),
    );

    await saveUserSession(updatedUser);
    return updatedUser;
  }

  @override
  Future<void> signOut() async {
    await clearUserSession();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  @override
  Future<void> saveUserSession(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs.setBool(_isAuthenticatedKey, true);
  }

  @override
  Future<void> clearUserSession() async {
    await _prefs.remove(_userKey);
    await _prefs.setBool(_isAuthenticatedKey, false);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
} 