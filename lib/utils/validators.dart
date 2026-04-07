// lib/utils/validators.dart
/// Input validators for forms
/// Provides validation for email, phone, password, and other common inputs
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Email validation
  /// Returns error message if invalid, null if valid
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  /// Password validation
  /// Minimum 8 characters, at least 1 letter and 1 number
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ cái';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 số';
    }

    return null;
  }

  /// Strong password validation
  /// Minimum 8 characters, uppercase, lowercase, number, special char
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    // Check for uppercase
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ hoa';
    }

    // Check for lowercase
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ thường';
    }

    // Check for number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 số';
    }

    // Check for special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
    }

    return null;
  }

  /// Confirm password validation
  /// Checks if password matches confirm password
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }

    if (value != password) {
      return 'Mật khẩu không khớp';
    }

    return null;
  }

  /// Phone number validation (Vietnam format)
  /// Accepts: 0xxxxxxxxx or +84xxxxxxxxx
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống';
    }

    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');

    // Vietnam phone regex
    // Accepts: 0xxxxxxxxx (10 digits) or +84xxxxxxxxx
    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');

    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Số điện thoại không hợp lệ';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }
    return null;
  }

  /// Minimum length validation
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }

    if (value.length < min) {
      return '${fieldName ?? 'Trường này'} phải có ít nhất $min ký tự';
    }

    return null;
  }

  /// Maximum length validation
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && value.length > max) {
      return '${fieldName ?? 'Trường này'} không được vượt quá $max ký tự';
    }
    return null;
  }

  /// Number validation
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }

    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'Trường này'} phải là số';
    }

    return null;
  }

  /// Number range validation
  static String? numberRange(String? value, int min, int max, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Trường này'} phải là số';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'Trường này'} phải từ $min đến $max';
    }

    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL không được để trống';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL không hợp lệ';
    }

    return null;
  }

  /// Username validation
  /// Alphanumeric, underscore, 3-20 characters
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên đăng nhập không được để trống';
    }

    if (value.length < 3 || value.length > 20) {
      return 'Tên đăng nhập phải từ 3-20 ký tự';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Tên đăng nhập chỉ được chứa chữ, số và dấu gạch dưới';
    }

    return null;
  }

  /// Full name validation
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Họ tên không được để trống';
    }

    if (value.trim().length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }

    // Check for at least one space (first name + last name)
    if (!value.trim().contains(' ')) {
      return 'Vui lòng nhập họ và tên';
    }

    return null;
  }

  /// Date validation (format: dd/MM/yyyy)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ngày không được để trống';
    }

    final dateRegex = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$');
    if (!dateRegex.hasMatch(value)) {
      return 'Định dạng ngày không hợp lệ (dd/MM/yyyy)';
    }

    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);
      
      // Check if date is valid
      if (date.day != day || date.month != month || date.year != year) {
        return 'Ngày không hợp lệ';
      }
    } catch (e) {
      return 'Ngày không hợp lệ';
    }

    return null;
  }

  /// Age validation (must be 18+)
  static String? age18Plus(String? value) {
    final dateError = date(value);
    if (dateError != null) return dateError;

    try {
      final parts = value!.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();
      final age = today.year - birthDate.year;

      if (age < 18 || (age == 18 && today.month < birthDate.month) ||
          (age == 18 && today.month == birthDate.month && today.day < birthDate.day)) {
        return 'Bạn phải từ 18 tuổi trở lên';
      }
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }

    return null;
  }

  /// Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}

/// Extension for easy validator usage
extension ValidatorExtension on String? {
  String? get validateEmail => Validators.email(this);
  String? get validatePassword => Validators.password(this);
  String? get validatePhone => Validators.phone(this);
  String? get validateRequired => Validators.required(this);
  String? get validateUsername => Validators.username(this);
  String? get validateFullName => Validators.fullName(this);
  String? get validateUrl => Validators.url(this);
}
