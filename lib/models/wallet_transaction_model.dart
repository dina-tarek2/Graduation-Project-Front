class WalletTransactionModel {
  final String id;
  final String userId;
  final String userType;
  final int amount;
  final String type; // "credit" or "debit"
  final String reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.userType,
    required this.amount,
    required this.type,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['_id'],
      userId: json['userId'],
      userType: json['userType'],
      amount: json['amount'],
      type: json['type'],
      reason: json['reason'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'userType': userType,
      'amount': amount,
      'type': type,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}
