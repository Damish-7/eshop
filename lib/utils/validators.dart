class Validators {
  static String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Name is required';
    if (val.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(val.trim())) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateConfirmPassword(String? val, String password) {
    if (val == null || val.isEmpty) return 'Please confirm your password';
    if (val != password) return 'Passwords do not match';
    return null;
  }

  static String? validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return null; // optional
    if (val.trim().length < 10) return 'Enter a valid phone number';
    return null;
  }

  static String? validateRequired(String? val, String fieldName) {
    if (val == null || val.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validatePrice(String? val) {
    if (val == null || val.trim().isEmpty) return 'Price is required';
    if (double.tryParse(val) == null) return 'Enter a valid price';
    if (double.parse(val) <= 0) return 'Price must be greater than 0';
    return null;
  }
}