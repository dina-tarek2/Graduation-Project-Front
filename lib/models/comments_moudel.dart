class DicomComment {
  final String id;
  final String userId;
  final String userType;
  final String image;
  final String name;
  final String recordId;
  final List<String> dicomComments;
  final DateTime createdAt;
  final DateTime updatedAt;

  DicomComment({
    required this.id,
    required this.userId,
    required this.userType,
    required this.image,
    required this.name,
    required this.recordId,
    required this.dicomComments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DicomComment.fromJson(Map<String, dynamic> json) {
    return DicomComment(
      id: json['_id'],
      userId: json['userId'],
      userType: json['userType'],
      image: json['image'],
      name: json['name'],
      recordId: json['recordId'],
      dicomComments: List<String>.from(json['dicom_Comment']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'userType': userType,
      'image': image,
      'name': name,
      'recordId': recordId,
      'dicom_Comment': dicomComments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
