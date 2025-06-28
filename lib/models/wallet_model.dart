// اختبار WalletModel
class WalletModel {
  final String id;
  final String ownerType;
  final String ownerId;
  final int version;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.version,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    print('Creating WalletModel from JSON: $json');

    try {
      // التحقق من وجود كل الحقول المطلوبة
      final id = json['_id'] as String?;
      final ownerType = json['ownerType'] as String?;
      final ownerId = json['ownerId'] as String?;
      final version = json['__v'] as int?;
      final balance = json['balance'];
      final createdAt = json['createdAt'] as String?;
      final updatedAt = json['updatedAt'] as String?;

      print('Parsed fields:');
      print('  id: $id');
      print('  ownerType: $ownerType');
      print('  ownerId: $ownerId');
      print('  version: $version');
      print('  balance: $balance (type: ${balance.runtimeType})');
      print('  createdAt: $createdAt');
      print('  updatedAt: $updatedAt');

      if (id == null) throw Exception('Missing _id field');
      if (ownerType == null) throw Exception('Missing ownerType field');
      if (ownerId == null) throw Exception('Missing ownerId field');
      if (version == null) throw Exception('Missing __v field');
      if (balance == null) throw Exception('Missing balance field');
      if (createdAt == null) throw Exception('Missing createdAt field');
      if (updatedAt == null) throw Exception('Missing updatedAt field');

      // تحويل balance إلى double
      double balanceDouble;
      if (balance is int) {
        balanceDouble = balance.toDouble();
      } else if (balance is double) {
        balanceDouble = balance;
      } else if (balance is String) {
        balanceDouble = double.parse(balance);
      } else {
        throw Exception('Invalid balance type: ${balance.runtimeType}');
      }

      return WalletModel(
        id: id,
        ownerType: ownerType,
        ownerId: ownerId,
        version: version,
        balance: balanceDouble,
        createdAt: DateTime.parse(createdAt),
        updatedAt: DateTime.parse(updatedAt),
      );
    } catch (e) {
      print('Error in WalletModel.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ownerType': ownerType,
      'ownerId': ownerId,
      '__v': version,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// دالة لاختبار النموذج مع البيانات الفعلية
void testWalletModel() {
  final testData = {
    "_id": "685b5f7e0ee9c6c61a948c7a",
    "ownerType": "RadiologyCenter",
    "ownerId": "68135192a9d8d429e412bc58",
    "__v": 0,
    "balance": 110,
    "createdAt": "2025-06-25T02:31:26.341Z",
    "updatedAt": "2025-06-26T10:48:54.915Z"
  };

  try {
    print('Testing WalletModel with data: $testData');
    final wallet = WalletModel.fromJson(testData);
    print('WalletModel created successfully!');
    print('Balance: ${wallet.balance}');
    print('Owner Type: ${wallet.ownerType}');
    print('Owner ID: ${wallet.ownerId}');
  } catch (e) {
    print('Error creating WalletModel: $e');
  }
}
