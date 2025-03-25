class RecordsListModel {
  final String id;
  final String centerName;
  final String radiologistId;
  final String reportId;
  final String patientName;
  final String patientId;
  final String sex;
  final String modality;
  final String? bodyPartExamined;
  final String email;
  final String dicomId;
  final String? series;
  final String status;
  final bool deleted;
  final String? aiReportResult;
  final DateTime studyDate;
  final DateTime? patientBirthDate;
  final int? age;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecordsListModel({
    required this.id,
    required this.centerName,
    required this.radiologistId,
    required this.patientName,
    required this.patientId,
    required this.sex,
    required this.modality,
    this.bodyPartExamined,
    required this.email,
    required this.dicomId,
    this.series,
    required this.status,
    required this.deleted,
    this.aiReportResult,
    required this.studyDate,
    this.patientBirthDate,
    this.age,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
        required this.reportId,
  });

  // convert JSON to Object
  factory RecordsListModel.fromJson(Map<String, dynamic> json) {
    return RecordsListModel(
      id: json['_id'],
      centerName: json['centerName'],
      radiologistId: json['radiologistId'],
      patientName: json['patient_name'],
      patientId: json['patient_id'],
      reportId: json['reportId'],
      sex: json['sex'],
      modality: json['modality'],
      bodyPartExamined: json['body_part_examined'],
      email: json['email'],
      dicomId: json['DicomId'],
      series: json['series'],
      status: json['status'],
      deleted: json['deleted'],
      aiReportResult: json['aiReportResult'],
      studyDate: DateTime.parse(json['study_date']),
      patientBirthDate: json['PatientBirthDate'] != null
          ? DateTime.tryParse(json['PatientBirthDate'])
          : null,
      age: json['age'] != "N/A" ? int.tryParse(json['age'].toString()) : null,
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
