import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/account.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;

  AuthService(this._apiService, this._storage);

  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await _apiService.post<LoginResponse>(
      '${_apiService.accountApiUrl}/account/login',
      request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    if (response.isSuccess && response.data != null) {
      await _storage.write(key: 'auth_token', value: response.data!.token);
    }

    return response;
  }

  Future<ApiResponse<CreateAccountResponse>> register(CreateAccountRequest request) async {
    return await _apiService.post<CreateAccountResponse>(
      '${_apiService.accountApiUrl}/account/register',
      request.toJson(),
      fromJson: (json) => CreateAccountResponse.fromJson(json),
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'user_data', value: userData.toString());
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: 'user_data');
  }
}
