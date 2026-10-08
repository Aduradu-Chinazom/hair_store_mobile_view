import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/auth_storage_service.dart';
import 'api_config.dart';
import 'api_exception.dart';

/// Central API Client handling HTTP methods, headers, token authorization,
/// timeout and network exception processing.
class ApiClient {
  final http.Client _client;
  final AuthStorageService _storageService;

  ApiClient({
    http.Client? client,
    AuthStorageService? storageService,
  })  : _client = client ?? http.Client(),
        _storageService = storageService ?? AuthStorageService();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final base = ApiConfig.baseUrl.endsWith('/')
        ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
        : ApiConfig.baseUrl;

    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '$base$path';

    return Uri.parse(fullUrl).replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    return _sendRequest(() async {
      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      return await _client.get(uri, headers: headers).timeout(ApiConfig.timeout);
    });
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    return _sendRequest(() async {
      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      return await _client
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);
    });
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    return _sendRequest(() async {
      final uri = _buildUri(endpoint);
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      return await _client
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);
    });
  }

  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    return _sendRequest(() async {
      final uri = _buildUri(endpoint);
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      return await _client.delete(uri, headers: headers).timeout(ApiConfig.timeout);
    });
  }

  Future<dynamic> _sendRequest(Future<http.Response> Function() requestCall) async {
    try {
      if (ApiConfig.baseUrl == 'API_BASE_URL_NOT_CONFIGURED') {
        throw const ApiException(
          message: 'Backend API is not yet configured.',
        );
      }

      final response = await requestCall();
      return _processResponse(response);
    } on SocketException {
      throw const ApiException(
        message: 'No internet connection. Please check your network and try again.',
      );
    } on TimeoutException {
      throw const ApiException(
        message: 'Request timed out. Please try again.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Network error occurred: ${e.toString()}');
    }
  }

  dynamic _processResponse(http.Response response) {
    dynamic responseData;
    if (response.body.isNotEmpty) {
      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = response.body;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      throw ApiException.fromStatusCode(response.statusCode, responseData);
    }
  }
}
