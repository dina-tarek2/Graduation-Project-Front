class AppNotification {
  final String _id;
  final String userId;
  final String userType;
  final String title;
  final String message;
  final String icon;
  final String sound;
  final bool isRead;
  final DateTime? createdAt; 
  final DateTime? updatedAt; 

  AppNotification({
    required String id,
    required this.userId,
    required this.userType,
    required this.title,
    required this.message,
    required this.icon,
    required this.sound,
    required this.isRead,
    required this.createdAt,
    this.updatedAt, // يمكن إضافته إذا كان مهمًا
  }) : _id = id;

  String get id => _id;

  // إضافة copyWith لتحديث الحقول
  AppNotification copyWith({
    String? id,
    String? userId,
    String? userType,
    String? title,
    String? message,
    String? icon,
    String? sound,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this._id,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      sound: sound ?? this.sound,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // دالة من أجل تحويل JSON إلى كائن
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'],
      userId: json['userId'],
      userType: json['userType'],
      title: json['title'],
      message: json['message'],
      icon: json['icon'],
      sound: json['sound'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']), // إذا كان موجودًا
    );
  }

  @override
  String toString() {
    return 'AppNotification{id: $id, userId: $userId, userType: $userType, title: $title, message: $message, icon: $icon, sound: $sound, isRead: $isRead, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
