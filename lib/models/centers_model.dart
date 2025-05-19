class Center0 {
  final String id;
  final String centerName;
  final String contactNumber;
  final String email;
  final String imageUrl;
  final bool isApproved;
  final Map<String, dynamic> address;
  final Map<String, dynamic> emergencyContact;
  final Map<String, dynamic> operatingHours;
  final Map<String, dynamic> recordsCountPerDay;
  final List<dynamic> facilities;
  final List<dynamic> certifications;
  final String createdAt;
  final String updatedAt;

  Center0({
    required this.id,
    required this.centerName,
    required this.contactNumber,
    required this.email,
    required this.imageUrl,
    required this.isApproved,
    required this.address,
    required this.emergencyContact,
    required this.operatingHours,
    required this.recordsCountPerDay,
    required this.facilities,
    required this.certifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Center0.fromJson(Map<String, dynamic> json) {
    return Center0(
      id: json["id"] ?? '',
      centerName: json["centerName"] ?? '',
      contactNumber: json["contactNumber"] ?? '',
      email: json["email"] ?? '',
      imageUrl: json["image"] ?? '',
      isApproved: json["isApproved"] ?? false,
      address: json["address"] ?? {},
      emergencyContact: json["emergencyContact"] ?? {},
      operatingHours: json["operatingHours"] ?? {},
      recordsCountPerDay: json["recordsCountPerDay"] ?? {},
      facilities: json["facilities"] ?? [],
      certifications: json["certifications"] ?? [],
      createdAt: json["createdAt"] ?? '',
      updatedAt: json["updatedAt"] ?? '',
    );
  }
}
