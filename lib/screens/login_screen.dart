import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _obscure   = true.obs;
  final _auth      = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size        = MediaQuery.of(context).size;
    final isWide      = size.width > 600;
    final hPadding    = isWide ? size.width * 0.25 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical:   24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width:  90,
                    height: 90,
                    decoration: BoxDecoration(
                      color:        AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:      AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset:     const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      size:  75,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize:   28,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Login to your eShop account',
                  style: TextStyle(
                    fontSize: 15,
                    color:    AppColors.grey,
                  ),
                ),
                const SizedBox(height: 36),
                // Email Field
                TextFormField(
                  controller:   _emailCtrl,
                  validator:    Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText:  'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                Obx(() => TextFormField(
                  controller:  _passCtrl,
                  validator:   Validators.validatePassword,
                  obscureText: _obscure.value,
                  decoration: InputDecoration(
                    labelText:  'Password',
                    prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: () => _obscure.value = !_obscure.value,
                    ),
                  ),
                )),
                const SizedBox(height: 28),
                // Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _auth.isLoading.value ? null : _submit,
                    child: _auth.isLoading.value
                        ? const SizedBox(
                            width:  22,
                            height: 22,
                            child:  CircularProgressIndicator(
                              color:       Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize:   17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )),
                const SizedBox(height: 20),
                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.grey),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/register'),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            color:      AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Admin hint
                // Center(
                //   child: Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color:        AppColors.primary.withOpacity(0.08),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: const Column(
                //       children: [
                //         Text(
                //           'Admin Login',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color:      AppColors.primary,
                //           ),
                //         ),
                //         SizedBox(height: 4),
                //         Text(
                //           'Email: admin@eshop.com',
                //           style: TextStyle(fontSize: 12, color: AppColors.grey),
                //         ),
                //         Text(
                //           'Password: admin123',
                //           style: TextStyle(fontSize: 12, color: AppColors.grey),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _auth.login(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
    }
  }
}