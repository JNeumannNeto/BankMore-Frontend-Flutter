import 'package:flutter/material.dart';
import '../models/fee.dart';
import '../services/fee_service.dart';

class FeeProvider extends ChangeNotifier {
  final FeeService _feeService;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Fee> _fees = [];

  FeeProvider(this._feeService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Fee> get fees => _fees;

  Future<void> loadFees(String accountNumber) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _feeService.getFeesByAccount(accountNumber);

      if (response.isSuccess && response.data != null) {
        _fees = response.data!;
      } else {
        _setError(response.error ?? 'Erro ao carregar tarifas');
        _fees = [];
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      _fees = [];
    }

    _setLoading(false);
  }

  Future<Fee?> getFeeById(int id) async {
    try {
      final response = await _feeService.getFeeById(id);
      
      if (response.isSuccess) {
        return response.data;
      } else {
        _setError(response.error ?? 'Erro ao buscar tarifa');
        return null;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      return null;
    }
  }

  double get totalFees {
    return _fees.fold(0.0, (sum, fee) => sum + fee.amount);
  }

  List<Fee> get transferFees {
    return _fees.where((fee) => fee.type.toUpperCase() == 'TRANSFER').toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
