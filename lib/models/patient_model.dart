class Patient {
  final String id;
  final String centerId;
  final String radiologistId;
  final String patientName;
  final DateTime studyDate;
  final String patientId;
  final String sex;
  final String modality;
  final DateTime patientBirthDate;
  final String age;
  final String email;
  final String dicomId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.centerId,
    required this.radiologistId,
    required this.patientName,
    required this.studyDate,
    required this.patientId,
    required this.sex,
    required this.modality,
    required this.patientBirthDate,
    required this.age,
    required this.email,
    required this.dicomId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      centerId: json['centerId'],
      radiologistId: json['radiologistId'],
      patientName: json['patient_name'],
      studyDate: DateTime.parse(json['study_date']),
      patientId: json['patient_id'],
      sex: json['sex'],
      modality: json['modality'],
      patientBirthDate: DateTime.parse(json['PatientBirthDate']),
      age: json['age'],
      email: json['email'],
      dicomId: json['DicomId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
