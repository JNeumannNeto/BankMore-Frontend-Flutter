import '../models/transfer.dart';
import 'api_service.dart';

class TransferService {
  final ApiService _apiService;

  TransferService(this._apiService);

  Future<ApiResponse<CreateTransferResponse>> createTransfer(CreateTransferRequest request) async {
    return await _apiService.post<CreateTransferResponse>(
      '${_apiService.transferApiUrl}/transfer',
      request.toJson(),
      requiresAuth: true,
      fromJson: (json) => CreateTransferResponse.fromJson(json),
    );
  }
}
