class Doctor {
  final String id;
  final String firstName;
  final String lastName;

  final List<dynamic> specialization;
  final String contactNumber;
  final String email;
  final String status;
  final String imageUrl;
  final int experience;
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
    required this.experience,
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
      experience: json["experience"] ?? '',
      numberOfReports: (json["numberOfReports"] ?? []
),
    );
  }

    String get fullName => '$firstName $lastName';
  num get totalReports {
    num count = 0;
    numberOfReports.forEach((key, value) {
      count += value.length;
    });
    return count;
  }
}
