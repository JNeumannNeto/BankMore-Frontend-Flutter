enum MovementType {
  credit('C'),
  debit('D');

  const MovementType(this.value);
  final String value;

  static MovementType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'C':
        return MovementType.credit;
      case 'D':
        return MovementType.debit;
      default:
        throw ArgumentError('Invalid movement type: $value');
    }
  }
}

class Movement {
  final String id;
  final String accountId;
  final DateTime movementDate;
  final MovementType type;
  final double amount;
  final String? idempotencyKey;

  Movement({
    required this.id,
    required this.accountId,
    required this.movementDate,
    required this.type,
    required this.amount,
    this.idempotencyKey,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'] ?? '',
      accountId: json['accountId'] ?? '',
      movementDate: DateTime.parse(json['movementDate']),
      type: MovementType.fromString(json['type']),
      amount: (json['amount'] ?? 0.0).toDouble(),
      idempotencyKey: json['idempotencyKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'movementDate': movementDate.toIso8601String(),
      'type': type.value,
      'amount': amount,
      'idempotencyKey': idempotencyKey,
    };
  }
}

class CreateMovementRequest {
  final String requestId;
  final String accountNumber;
  final double amount;
  final String type;

  CreateMovementRequest({
    required this.requestId,
    required this.accountNumber,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'accountNumber': accountNumber,
      'amount': amount,
      'type': type,
    };
  }
}
