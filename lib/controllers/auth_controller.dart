import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> user      = Rx<UserModel?>(null);
  final RxBool         isLoading = false.obs;

  bool get isLoggedIn => user.value != null;
  bool get isAdmin    => user.value?.isAdmin ?? false;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromPrefs();
  }

  // Load saved user from SharedPreferences
  Future<void> _loadUserFromPrefs() async {
    final prefs    = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      user.value = UserModel.fromJson(jsonDecode(userData));
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToPrefs(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userData));
  }

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    isLoading.value = true;
    try {
      final res = await ApiService.register({
        'name':     name,
        'email':    email,
        'password': password,
        'phone':    phone,
      });

      if (res['status'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Registration successful',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Registration failed',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Try again.',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final res = await ApiService.login(email, password);

      if (res['status'] == true) {
        final userData = res['user'] as Map<String, dynamic>;
        user.value     = UserModel.fromJson(userData);
        await _saveUserToPrefs(userData);

        Get.snackbar(
          'Welcome!',
          'Hello, ${user.value!.name}',
          backgroundColor: Colors.green,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );

        if (user.value!.isAdmin) {
          Get.offAllNamed('/admin');
        } else {
          Get.offAllNamed('/home');
        }
      } else {
        Get.snackbar(
          'Login Failed',
          res['message'] ?? 'Invalid credentials',
          backgroundColor: Colors.red,
          colorText:       Colors.white,
          snackPosition:   SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Try again.',
        backgroundColor: Colors.red,
        colorText:       Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    user.value  = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Get.offAllNamed('/login');
  }
}