import '../models/fee.dart';
import 'api_service.dart';

class FeeService {
  final ApiService _apiService;

  FeeService(this._apiService);

  Future<ApiResponse<List<Fee>>> getFeesByAccount(String accountNumber) async {
    final response = await _apiService.get<List<dynamic>>(
      '${_apiService.feeApiUrl}/fee/$accountNumber',
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      final fees = (response.data as List<dynamic>)
          .map((json) => Fee.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(fees);
    }

    return ApiResponse.error(response.error ?? 'Erro ao buscar tarifas');
  }

  Future<ApiResponse<Fee>> getFeeById(int id) async {
    return await _apiService.get<Fee>(
      '${_apiService.feeApiUrl}/fee/fee/$id',
      requiresAuth: false,
      fromJson: (json) => Fee.fromJson(json),
    );
  }
}
