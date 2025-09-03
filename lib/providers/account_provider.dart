import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/account.dart';
import '../models/movement.dart';
import '../services/account_service.dart';

class AccountProvider extends ChangeNotifier {
  final AccountService _accountService;
  
  bool _isLoading = false;
  String? _errorMessage;
  BalanceResponse? _balance;

  AccountProvider(this._accountService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BalanceResponse? get balance => _balance;

  Future<void> loadBalance() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _accountService.getBalance();

      if (response.isSuccess && response.data != null) {
        _balance = response.data;
      } else {
        _setError(response.error ?? 'Erro ao carregar saldo');
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
    }

    _setLoading(false);
  }

  Future<BalanceResponse?> getBalanceByAccountNumber(String accountNumber) async {
    try {
      final response = await _accountService.getBalanceByAccountNumber(accountNumber);
      
      if (response.isSuccess) {
        return response.data;
      } else {
        _setError(response.error ?? 'Erro ao buscar conta');
        return null;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      return null;
    }
  }

  Future<bool> checkAccountExists(String accountNumber) async {
    try {
      final response = await _accountService.accountExists(accountNumber);
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> makeDeposit(double amount) async {
    if (_balance == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final request = CreateMovementRequest(
        requestId: const Uuid().v4(),
        accountNumber: _balance!.accountNumber,
        amount: amount,
        type: 'C',
      );

      final response = await _accountService.createMovement(request);

      if (response.isSuccess) {
        await loadBalance();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erro ao fazer depósito');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> makeWithdrawal(double amount) async {
    if (_balance == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final request = CreateMovementRequest(
        requestId: const Uuid().v4(),
        accountNumber: _balance!.accountNumber,
        amount: amount,
        type: 'D',
      );

      final response = await _accountService.createMovement(request);

      if (response.isSuccess) {
        await loadBalance();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erro ao fazer saque');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deactivateAccount(String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _accountService.deactivateAccount(password);

      if (response.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Erro ao inativar conta');
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

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
