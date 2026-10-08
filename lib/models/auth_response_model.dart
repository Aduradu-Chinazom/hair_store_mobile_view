import 'user_model.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;
  final String? message;

  const AuthResponseModel({
    required this.token,
    required this.user,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token']?.toString() ??
        json['access_token']?.toString() ??
        json['data']?['token']?.toString() ??
        '';

    final userData = json['user'] as Map<String, dynamic>? ??
        json['data']?['user'] as Map<String, dynamic>? ??
        json;

    return AuthResponseModel(
      token: token,
      user: UserModel.fromJson(userData),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'message': message,
    };
  }
}
