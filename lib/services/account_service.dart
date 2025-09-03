import '../models/account.dart';
import '../models/movement.dart';
import 'api_service.dart';

class AccountService {
  final ApiService _apiService;

  AccountService(this._apiService);

  Future<ApiResponse<BalanceResponse>> getBalance() async {
    return await _apiService.get<BalanceResponse>(
      '${_apiService.accountApiUrl}/account/balance',
      requiresAuth: true,
      fromJson: (json) => BalanceResponse.fromJson(json),
    );
  }

  Future<ApiResponse<BalanceResponse>> getBalanceByAccountNumber(String accountNumber) async {
    return await _apiService.get<BalanceResponse>(
      '${_apiService.accountApiUrl}/account/balance/$accountNumber',
      requiresAuth: false,
      fromJson: (json) => BalanceResponse.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> accountExists(String accountNumber) async {
    final response = await _apiService.get<bool>(
      '${_apiService.accountApiUrl}/account/exists/$accountNumber',
      requiresAuth: false,
    );
    
    return response;
  }

  Future<ApiResponse<void>> createMovement(CreateMovementRequest request) async {
    return await _apiService.post<void>(
      '${_apiService.accountApiUrl}/account/movement',
      request.toJson(),
      requiresAuth: true,
    );
  }

  Future<ApiResponse<void>> deactivateAccount(String password) async {
    return await _apiService.put<void>(
      '${_apiService.accountApiUrl}/account/deactivate',
      {'password': password},
      requiresAuth: true,
    );
  }
}
