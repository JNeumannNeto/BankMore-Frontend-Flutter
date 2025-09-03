import 'package:intl/intl.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  static String formatCurrency(double value) {
    return _currencyFormat.format(value);
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatCpf(String cpf) {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
  }

  static String formatAccountNumber(String accountNumber) {
    if (accountNumber.length < 6) return accountNumber;
    return '${accountNumber.substring(0, accountNumber.length - 1)}-${accountNumber.substring(accountNumber.length - 1)}';
  }

  static String removeCpfFormatting(String cpf) {
    return cpf.replaceAll(RegExp(r'[^\d]'), '');
  }

  static bool isValidCpf(String cpf) {
    final cleanCpf = removeCpfFormatting(cpf);
    return CPFValidator.isValid(cleanCpf);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidAmount(String amount) {
    try {
      final value = double.parse(amount.replaceAll(',', '.'));
      return value > 0;
    } catch (e) {
      return false;
    }
  }

  static double parseAmount(String amount) {
    return double.parse(amount.replaceAll(',', '.'));
  }

  static String maskCpf(String cpf) {
    if (cpf.length < 11) return cpf;
    return '***.***.***-${cpf.substring(9)}';
  }

  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length < 4) return accountNumber;
    return '****${accountNumber.substring(accountNumber.length - 2)}';
  }
}

class CpfInputFormatter {
  static String format(String value) {
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (value.length <= 3) {
      return value;
    } else if (value.length <= 6) {
      return '${value.substring(0, 3)}.${value.substring(3)}';
    } else if (value.length <= 9) {
      return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6)}';
    } else {
      return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9, 11)}';
    }
  }
}

class CurrencyInputFormatter {
  static String format(String value) {
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (value.isEmpty) return '';
    
    final intValue = int.parse(value);
    final doubleValue = intValue / 100;
    
    return Formatters.formatCurrency(doubleValue);
  }
}
