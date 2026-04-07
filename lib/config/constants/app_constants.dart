// lib/config/constants/app_constants.dart
/// Application-wide constants
/// Centralized configuration for the FoodTour app
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ==================== API Configuration ====================
  
  /// API timeout duration
  static const Duration apiTimeout = Duration(seconds: 15);
  
  /// API connect timeout
  static const Duration apiConnectTimeout = Duration(seconds: 15);
  
  /// API receive timeout
  static const Duration apiReceiveTimeout = Duration(seconds: 15);
  
  /// Rate limiting - minimum interval between requests
  static const Duration rateLimitInterval = Duration(milliseconds: 500);
  
  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;
  
  // ==================== Storage Keys ====================
  
  /// Secure storage key for auth token
  static const String authTokenKey = 'auth_token';
  
  /// Secure storage key for refresh token
  static const String refreshTokenKey = 'refresh_token';
  
  /// Secure storage key for user ID
  static const String userIdKey = 'user_id';
  
  /// Hive box name for user data
  static const String userBoxKey = 'userBox';
  
  /// Hive box name for restaurants
  static const String restaurantsBoxKey = 'restaurants';
  
  // ==================== Validation Rules ====================
  
  /// Minimum password length
  static const int minPasswordLength = 8;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;
  
  /// Minimum username length
  static const int minUsernameLength = 3;
  
  /// Maximum username length
  static const int maxUsernameLength = 20;
  
  /// Minimum full name length
  static const int minFullNameLength = 2;
  
  /// Maximum full name length
  static const int maxFullNameLength = 100;
  
  /// Minimum age requirement
  static const int minAge = 18;
  
  // ==================== Regex Patterns ====================
  
  /// Email validation regex
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  /// Phone validation regex (Vietnam)
  static const String phoneRegex = r'^(0|\+84)[0-9]{9}$';
  
  /// Username validation regex
  static const String usernameRegex = r'^[a-zA-Z0-9_]+$';
  
  /// URL validation regex
  static const String urlRegex = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  
  /// Date format regex (dd/MM/yyyy)
  static const String dateRegex = r'^(\d{2})\/(\d{2})\/(\d{4})$';
  
  // ==================== UI Configuration ====================
  
  /// Design size for ScreenUtil
  static const double designWidth = 375;
  static const double designHeight = 812;
  
  /// Default padding
  static const double defaultPadding = 16.0;
  
  /// Default border radius
  static const double defaultBorderRadius = 8.0;
  
  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // ==================== Pagination ====================
  
  /// Default page size for lists
  static const int defaultPageSize = 20;
  
  /// Maximum page size
  static const int maxPageSize = 100;
  
  // ==================== Cache Configuration ====================
  
  /// Cache duration for images
  static const Duration imageCacheDuration = Duration(days: 7);
  
  /// Cache duration for API responses
  static const Duration apiCacheDuration = Duration(minutes: 5);
  
  /// Maximum cache size (MB)
  static const int maxCacheSize = 100;
  
  // ==================== Firebase Configuration ====================
  
  /// Firestore collection names
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String reviewsCollection = 'reviews';
  static const String favoritesCollection = 'favorites';
  
  // ==================== Error Messages ====================
  
  /// Generic error message
  static const String genericError = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
  
  /// Network error message
  static const String networkError = 'Không có kết nối mạng. Vui lòng kiểm tra và thử lại.';
  
  /// Timeout error message
  static const String timeoutError = 'Yêu cầu quá thời gian. Vui lòng thử lại.';
  
  /// Unauthorized error message
  static const String unauthorizedError = 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
  
  /// Rate limit error message
  static const String rateLimitError = 'Bạn đang thao tác quá nhanh. Vui lòng chờ một chút.';
  
  // ==================== Success Messages ====================
  
  /// Login success
  static const String loginSuccess = 'Đăng nhập thành công!';
  
  /// Logout success
  static const String logoutSuccess = 'Đăng xuất thành công!';
  
  /// Sign up success
  static const String signUpSuccess = 'Đăng ký thành công!';
  
  /// Profile update success
  static const String profileUpdateSuccess = 'Cập nhật thông tin thành công!';
  
  /// Password change success
  static const String passwordChangeSuccess = 'Đổi mật khẩu thành công!';
  
  // ==================== App Information ====================
  
  /// App name
  static const String appName = 'FoodTour Cộng Đồng';
  
  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.1.0';
  
  /// App build number
  static const int appBuildNumber = 1;
  
  /// Support email
  static const String supportEmail = 'support@foodtour.vn';
  
  /// Privacy policy URL
  static const String privacyPolicyUrl = 'https://foodtour.vn/privacy';
  
  /// Terms of service URL
  static const String termsOfServiceUrl = 'https://foodtour.vn/terms';
  
  // ==================== Social Media ====================
  
  /// Facebook page URL
  static const String facebookUrl = 'https://facebook.com/foodtour';
  
  /// Instagram profile URL
  static const String instagramUrl = 'https://instagram.com/foodtour';
  
  /// Twitter profile URL
  static const String twitterUrl = 'https://twitter.com/foodtour';
  
  // ==================== Feature Flags ====================
  
  /// Enable debug mode
  static const bool enableDebugMode = true;
  
  /// Enable analytics
  static const bool enableAnalytics = true;
  
  /// Enable crashlytics
  static const bool enableCrashlytics = true;
  
  /// Enable push notifications
  static const bool enablePushNotifications = true;
  
  /// Enable biometric authentication
  static const bool enableBiometricAuth = true;
  
  // ==================== Date & Time Formats ====================
  
  /// Date format for display
  static const String displayDateFormat = 'dd/MM/yyyy';
  
  /// Time format for display
  static const String displayTimeFormat = 'HH:mm';
  
  /// DateTime format for display
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  /// ISO 8601 format for API
  static const String isoDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
}
