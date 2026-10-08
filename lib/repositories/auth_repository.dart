import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../services/api/api_client.dart';
import '../services/storage/auth_storage_service.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login({required String email, required String password});
  Future<AuthResponseModel> register({required String email, required String password});
  Future<void> sendPasswordResetEmail({required String emailOrPhone});
  Future<bool> verifyOtp({required String email, required String otp});
  Future<void> resetPassword({required String newPassword});
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

/// Implementation of [AuthRepository].
///
/// TODO(API INTEGRATION):
/// Replace mock response blocks with [_apiClient] endpoints once the Postman collection is provided.
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final AuthStorageService _storageService;

  AuthRepositoryImpl({
    ApiClient? apiClient,
    AuthStorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService = storageService ?? AuthStorageService();

  ApiClient get apiClient => _apiClient;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.login, body: {'email': email, 'password': password});
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }

    const mockToken = 'mock_jwt_token_hair_haven_12345';
    final mockUser = UserModel(
      id: 'usr_1001',
      email: email.trim(),
      name: email.split('@').first,
    );

    await _storageService.saveToken(mockToken);
    await _storageService.saveUserData(mockUser.toJson());

    return AuthResponseModel(
      token: mockToken,
      user: mockUser,
      message: 'Logged in successfully',
    );
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
  }) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.register, body: {'email': email, 'password': password});
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }

    const mockToken = 'mock_jwt_token_hair_haven_12345';
    final mockUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
    );

    await _storageService.saveToken(mockToken);
    await _storageService.saveUserData(mockUser.toJson());

    return AuthResponseModel(
      token: mockToken,
      user: mockUser,
      message: 'Account created successfully',
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String emailOrPhone}) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.forgotPassword, body: {'emailOrPhone': emailOrPhone});
    await Future.delayed(const Duration(milliseconds: 400));
    if (emailOrPhone.trim().isEmpty) {
      throw Exception('Email or phone number is required.');
    }
  }

  @override
  Future<bool> verifyOtp({required String email, required String otp}) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.resetPassword, body: {'email': email, 'otp': otp});
    await Future.delayed(const Duration(milliseconds: 400));
    return otp.length == 4;
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    // TODO(API INTEGRATION): Replace with _apiClient.post(ApiConfig.resetPassword, body: {'password': newPassword});
    await Future.delayed(const Duration(milliseconds: 400));
    if (newPassword.length < 8) {
      throw Exception('Password must be at least 8 characters long.');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final hasToken = await _storageService.hasValidToken();
    if (!hasToken) return null;

    final userData = await _storageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _storageService.clearAuthSession();
  }
}
