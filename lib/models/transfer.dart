enum TransferStatus {
  pending,
  completed,
  failed;

  static TransferStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return TransferStatus.pending;
      case 'completed':
        return TransferStatus.completed;
      case 'failed':
        return TransferStatus.failed;
      default:
        throw ArgumentError('Invalid transfer status: $value');
    }
  }

  String get displayName {
    switch (this) {
      case TransferStatus.pending:
        return 'Pendente';
      case TransferStatus.completed:
        return 'Concluída';
      case TransferStatus.failed:
        return 'Falhou';
    }
  }
}

class Transfer {
  final String id;
  final String originAccountId;
  final String destinationAccountId;
  final DateTime transferDate;
  final double amount;
  final TransferStatus status;
  final DateTime? completedAt;
  final String? description;
  final String? idempotencyKey;

  Transfer({
    required this.id,
    required this.originAccountId,
    required this.destinationAccountId,
    required this.transferDate,
    required this.amount,
    required this.status,
    this.completedAt,
    this.description,
    this.idempotencyKey,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'] ?? '',
      originAccountId: json['originAccountId'] ?? '',
      destinationAccountId: json['destinationAccountId'] ?? '',
      transferDate: DateTime.parse(json['transferDate']),
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: TransferStatus.fromString(json['status']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      description: json['description'],
      idempotencyKey: json['idempotencyKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originAccountId': originAccountId,
      'destinationAccountId': destinationAccountId,
      'transferDate': transferDate.toIso8601String(),
      'amount': amount,
      'status': status.name,
      'completedAt': completedAt?.toIso8601String(),
      'description': description,
      'idempotencyKey': idempotencyKey,
    };
  }
}

class CreateTransferRequest {
  final String requestId;
  final String destinationAccountNumber;
  final double amount;

  CreateTransferRequest({
    required this.requestId,
    required this.destinationAccountNumber,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'destinationAccountNumber': destinationAccountNumber,
      'amount': amount,
    };
  }
}

class CreateTransferResponse {
  final String transferId;
  final String message;

  CreateTransferResponse({
    required this.transferId,
    required this.message,
  });

  factory CreateTransferResponse.fromJson(Map<String, dynamic> json) {
    return CreateTransferResponse(
      transferId: json['transferId'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
