/// Centralized configuration for API endpoints and base URL.
///
/// TODO(API INTEGRATION):
/// Replace [baseUrl] with the actual backend API base URL once the Postman collection is provided.
class ApiConfig {
  static const String baseUrl = 'API_BASE_URL_NOT_CONFIGURED';

  static const Duration timeout = Duration(seconds: 30);

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String userProfile = '/auth/profile';

  static const String products = '/products';
  static const String categories = '/categories';
  static String productDetail(String id) => '/products/$id';

  static const String cart = '/cart';
  static String cartItem(String id) => '/cart/$id';

  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';
}
