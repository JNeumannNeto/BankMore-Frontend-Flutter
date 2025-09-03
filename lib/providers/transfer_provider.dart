import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transfer.dart';
import '../services/transfer_service.dart';

class TransferProvider extends ChangeNotifier {
  final TransferService _transferService;
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  TransferProvider(this._transferService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> makeTransfer(String destinationAccountNumber, double amount) async {
    _setLoading(true);
    _clearMessages();

    try {
      final request = CreateTransferRequest(
        requestId: const Uuid().v4(),
        destinationAccountNumber: destinationAccountNumber,
        amount: amount,
      );

      final response = await _transferService.createTransfer(request);

      if (response.isSuccess && response.data != null) {
        _setSuccessMessage(response.data!.message);
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erro ao realizar transferência');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _clearMessages();
  }
}
