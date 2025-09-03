class Fee {
  final int id;
  final String accountNumber;
  final double amount;
  final String type;
  final String description;
  final DateTime createdAt;
  final String requestId;

  Fee({
    required this.id,
    required this.accountNumber,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
    required this.requestId,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: json['id'] ?? 0,
      accountNumber: json['accountNumber'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      requestId: json['requestId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'amount': amount,
      'type': type,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'requestId': requestId,
    };
  }

  String get typeDisplayName {
    switch (type.toUpperCase()) {
      case 'TRANSFER':
        return 'Transferência';
      case 'WITHDRAWAL':
        return 'Saque';
      case 'DEPOSIT':
        return 'Depósito';
      default:
        return type;
    }
  }
}
