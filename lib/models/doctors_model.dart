class Doctor {
  final String id;
  final String firstName;
  final String lastName;

  final List<dynamic> specialization;
  final String contactNumber;
  final String email;
  final String status;
  final String imageUrl;
  final Map<String, dynamic> numberOfReports;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.contactNumber,
    required this.email,
    required this.status,
    required this.imageUrl,
    required this.numberOfReports,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json["_id"] ?? '',
      firstName: json["firstName"] ?? '',
      lastName: json["lastName"] ?? '',
      specialization: json["specialization"] ?? [],
      contactNumber: json["contactNumber"] ?? '',
      email: json["email"] ?? '',
      status: json["status"] ?? '',
      imageUrl: json["image"] ?? '',
      numberOfReports: json["numberOfReports"] ?? [],
    );
  }
}
