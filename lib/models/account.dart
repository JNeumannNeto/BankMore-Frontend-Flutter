class Account {
  final String id;
  final int number;
  final String name;
  final String cpf;
  final bool active;

  Account({
    required this.id,
    required this.number,
    required this.name,
    required this.cpf,
    required this.active,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      cpf: json['cpf'] ?? '',
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'cpf': cpf,
      'active': active,
    };
  }
}

class CreateAccountRequest {
  final String cpf;
  final String name;
  final String password;

  CreateAccountRequest({
    required this.cpf,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'name': name,
      'password': password,
    };
  }
}

class CreateAccountResponse {
  final int accountNumber;

  CreateAccountResponse({required this.accountNumber});

  factory CreateAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateAccountResponse(
      accountNumber: json['accountNumber'] ?? 0,
    );
  }
}

class LoginRequest {
  final String? accountNumber;
  final String? cpf;
  final String password;

  LoginRequest({
    this.accountNumber,
    this.cpf,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (cpf != null) 'cpf': cpf,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
    );
  }
}

class BalanceResponse {
  final String accountNumber;
  final String accountName;
  final double balance;

  BalanceResponse({
    required this.accountNumber,
    required this.accountName,
    required this.balance,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      accountNumber: json['accountNumber']?.toString() ?? '',
      accountName: json['accountName'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
    );
  }
}
