import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _cpassCtrl = TextEditingController();
  final _obscure   = true.obs;
  final _obscureC  = true.obs;
  final _auth      = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.of(context).size;
    final isWide   = size.width > 600;
    final hPadding = isWide ? size.width * 0.25 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon:     const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: hPadding,
          vertical:   24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join eShop',
                style: TextStyle(
                  fontSize:   26,
                  fontWeight: FontWeight.bold,
                  color:      AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Create your account to start shopping',
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
              const SizedBox(height: 28),
              // Full Name
              TextFormField(
                controller: _nameCtrl,
                validator:  Validators.validateName,
                decoration: const InputDecoration(
                  labelText:  'Full Name',
                  prefixIcon: Icon(Icons.person_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              // Email
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
              // Phone
              TextFormField(
                controller:   _phoneCtrl,
                validator:    Validators.validatePhone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText:  'Phone Number (Optional)',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              // Password
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
              const SizedBox(height: 16),
              // Confirm Password
              Obx(() => TextFormField(
                controller:  _cpassCtrl,
                validator:   (v) =>
                    Validators.validateConfirmPassword(v, _passCtrl.text),
                obscureText: _obscureC.value,
                decoration: InputDecoration(
                  labelText:  'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureC.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: () => _obscureC.value = !_obscureC.value,
                  ),
                ),
              )),
              const SizedBox(height: 28),
              // Register Button
              Obx(() => SizedBox(
                width:  double.infinity,
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
                          'Create Account',
                          style: TextStyle(
                            fontSize:   17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              )),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.grey),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color:      AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _auth.register(
        name:     _nameCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
        phone:    _phoneCtrl.text.trim(),
      );
    }
  }
}