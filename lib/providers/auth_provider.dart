import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;
  String? _currentAccountNumber;
  String? _currentAccountName;

  AuthProvider(this._authService) {
    _checkLoginStatus();
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  String? get currentAccountNumber => _currentAccountNumber;
  String? get currentAccountName => _currentAccountName;

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    _clearError();

    try {
      LoginRequest request;
      
      if (identifier.contains('.') || identifier.contains('-')) {
        request = LoginRequest(cpf: identifier, password: password);
      } else {
        request = LoginRequest(accountNumber: identifier, password: password);
      }

      final response = await _authService.login(request);

      if (response.isSuccess) {
        _isLoggedIn = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Erro ao fazer login');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String cpf, String name, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = CreateAccountRequest(
        cpf: cpf,
        name: name,
        password: password,
      );

      final response = await _authService.register(request);

      if (response.isSuccess) {
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Erro ao criar conta');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Erro inesperado: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _currentAccountNumber = null;
    _currentAccountName = null;
    _clearError();
    notifyListeners();
  }

  void setCurrentAccountInfo(String accountNumber, String accountName) {
    _currentAccountNumber = accountNumber;
    _currentAccountName = accountName;
    notifyListeners();
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
