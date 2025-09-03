import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost';
  static const String _accountApiPort = '5001';
  static const String _transferApiPort = '5002';
  static const String _feeApiPort = '5003';
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String get accountApiUrl => '$_baseUrl:$_accountApiPort/api';
  String get transferApiUrl => '$_baseUrl:$_transferApiPort/api';
  String get feeApiUrl => '$_baseUrl:$_feeApiPort/api';

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String url, {
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Erro de conexão: ${e.toString()}');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Erro de conexão: ${e.toString()}');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Erro de conexão: ${e.toString()}');
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204) {
        return ApiResponse.success(null);
      }

      if (response.body.isEmpty) {
        return ApiResponse.success(null);
      }

      try {
        final jsonData = jsonDecode(response.body);
        
        if (fromJson != null && jsonData is Map<String, dynamic>) {
          final data = fromJson(jsonData);
          return ApiResponse.success(data);
        }
        
        return ApiResponse.success(jsonData as T?);
      } catch (e) {
        return ApiResponse.error('Erro ao processar resposta: ${e.toString()}');
      }
    } else {
      String errorMessage = 'Erro desconhecido';
      
      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map<String, dynamic>) {
          errorMessage = errorData['message'] ?? 
                        errorData['Message'] ?? 
                        'Erro ${response.statusCode}';
        }
      } catch (e) {
        errorMessage = 'Erro ${response.statusCode}';
      }

      return ApiResponse.error(errorMessage);
    }
  }
}

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse._({this.data, this.error, required this.isSuccess});

  factory ApiResponse.success(T? data) {
    return ApiResponse._(data: data, isSuccess: true);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(error: error, isSuccess: false);
  }
}
