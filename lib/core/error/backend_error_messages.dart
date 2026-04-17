/// Maps backend business codes (as emitted by the Laravel app controllers)
/// to English messages. Mirrors `lang/en/errors.php` on the server, plus
/// a few finer-grained messages that are hard-coded in controllers.
///
/// Look up by code first; fall back to the server-supplied `msg`, which
/// is often Chinese, as a last resort.
abstract class BackendErrorMessages {
  static const Map<String, String> _en = {
    // Auth
    'AUTH_001': 'Incorrect email or password',
    'AUTH_002': 'Session expired, please sign in again',
    'AUTH_003': 'You are not allowed to perform this action',
    'AUTH_004': 'Invalid credentials',

    // Validation
    'VALIDATION_001': 'Please check the fields and try again',
    'VALIDATION_002': 'Invalid parameter',
    'VALIDATION_003': 'A required field is missing',

    // Not found
    'NOT_FOUND_001': 'Not found',
    'NOT_FOUND_002': 'SIM not found',
    'NOT_FOUND_003': 'Package not found',
    'NOT_FOUND_004': 'Order not found',
    'NOT_FOUND_005': 'User not found',
    'NOT_FOUND_006': 'Operator not found',

    // Business
    'BUSINESS_001': 'Operation not allowed',
    'BUSINESS_002': 'Insufficient balance',
    'BUSINESS_003': 'SIM already activated',
    'BUSINESS_004': 'Invalid SIM status',
    'BUSINESS_005': 'Package not available',
    'BUSINESS_006': 'Your cart is empty',
    'BUSINESS_007': 'Order already paid',
    'BUSINESS_008': 'Invalid order status',

    // External
    'EXTERNAL_001': 'Carrier service is currently unavailable',
    'EXTERNAL_002': 'Payment gateway error',
    'EXTERNAL_003': 'Service timed out, please try again',
    'EXTERNAL_004': 'Verification service is unavailable',

    // Payment
    'PAYMENT_001': 'Payment required',
    'PAYMENT_002': 'Payment failed',
    'PAYMENT_003': 'Invalid payment method',
    'PAYMENT_004': 'Refund failed',

    // System
    'SYSTEM_001': 'Something went wrong on our side. Please try again.',
    'SYSTEM_002': 'Database error',
    'SYSTEM_003': 'Configuration error',
    'SYSTEM_004': 'Service temporarily unavailable',

    // Rate limit
    'RATE_LIMIT_001': 'Too many attempts. Please wait a moment and try again.',

    'UNKNOWN': 'Something went wrong, please try again.',
  };

  /// Substring → English hints for Chinese hard-coded `msg` values.
  /// Used when the code is generic (e.g. VALIDATION_001) but the message
  /// carries extra info.
  static const Map<String, String> _chineseHints = {
    '邮箱或密码错误': 'Incorrect email or password',
    '账户已被禁用': 'Your account has been disabled',
    '当前密码错误': 'Current password is incorrect',
    '您已绑定该SIM卡': 'You have already bound this SIM card',
    '绑定记录不存在': 'Binding record not found',
    '用户不存在': 'User not found',
    '请求过于频繁，请稍后再试': 'Too many requests. Please wait and try again.',
    '该邮箱已被注册': 'This email is already registered',
    '验证失败': 'Please check the fields and try again',
    '注册成功': 'Registration successful',
    '登录成功': 'Login successful',
    '成功': 'Success',
  };

  /// Laravel validation field errors, e.g. "The password confirmation does not match".
  /// These usually come in English, but translate a few Chinese ones.
  static const Map<String, String> _validationHints = {
    'password confirmation does not match':
        'The passwords you entered do not match',
    'has already been taken': 'is already in use',
    'email field is required': 'Email is required',
    'password field is required': 'Password is required',
    'must be at least': 'must be at least',
  };

  /// Translate a backend response to a user-friendly English message.
  ///
  /// Rules of precedence:
  /// 1. If validation errors exist in `data.errors.*[0]`, use that (already English).
  /// 2. If `code` maps directly to an English message, return that.
  /// 3. If `msg` contains a recognised Chinese phrase, return the mapped English.
  /// 4. Otherwise return `msg` as-is.
  static String translate({
    required String code,
    required String msg,
    Object? dataErrors,
  }) {
    final fieldError = _firstFieldError(dataErrors);
    if (fieldError != null && fieldError.isNotEmpty) {
      return _polishFieldError(fieldError);
    }

    final mapped = _en[code];
    if (mapped != null) return mapped;

    for (final entry in _chineseHints.entries) {
      if (msg.contains(entry.key)) return entry.value;
    }

    return msg.isEmpty ? 'Something went wrong, please try again.' : msg;
  }

  static String? _firstFieldError(Object? dataErrors) {
    if (dataErrors is! Map) return null;
    for (final v in dataErrors.values) {
      if (v is List && v.isNotEmpty && v.first is String) return v.first as String;
      if (v is String && v.isNotEmpty) return v;
    }
    return null;
  }

  static String _polishFieldError(String raw) {
    for (final entry in _validationHints.entries) {
      if (raw.toLowerCase().contains(entry.key)) {
        // Replace the matching fragment with the polished form.
        return raw.replaceFirst(
          RegExp(entry.key, caseSensitive: false),
          entry.value,
        );
      }
    }
    return raw;
  }
}
