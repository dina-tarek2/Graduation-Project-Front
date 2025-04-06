class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final  List<String> specialization;
  final String contactNumber;
  final String email;
  final String status;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.contactNumber,
    required this.email,
    required this.status,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      specialization: List<String>.from(json["specialization"] ?? []),
      contactNumber: json["contactNumber"],
      email: json["email"],
      status: json["status"],
    );
  }
}
