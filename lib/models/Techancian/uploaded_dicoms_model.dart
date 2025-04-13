class UploadedDicomModel {
  UploadedDicomModel({
    required this.numOfRecords,
    required this.records,
  });

  final int numOfRecords;
  final List<RecordModel> records;

  factory UploadedDicomModel.fromJson(Map<String, dynamic> json) {
    return UploadedDicomModel(
      numOfRecords: json["numOfRecords"] as int? ?? 0,
      records: (json["records"] as List<dynamic>?)
              ?.map((x) => RecordModel.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "numOfRecords": numOfRecords,
      "records": records.map((x) => x.toJson()).toList(),
    };
  }
}

class RecordModel {
  RecordModel({
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
    required this.bodyPartExamined,
    required this.email,
    required this.dicomId,
    required this.series,
    required this.status,
    required this.deleted,
    required this.dicomUrl,
    required this.studyDescription,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.reportId,
    required this.radiologistName,
  });

  final String id;
  final String centerId;
  final String radiologistId;
  final String patientName;
  final DateTime? studyDate;
  final String patientId;
  final String sex;
  final String modality;
  final DateTime? patientBirthDate;
  final String age;
  final String bodyPartExamined;
  final String email;
  final String dicomId;
  final String series;
  final String status;
  final bool deleted;
  final String dicomUrl;
  final String studyDescription;
  final DateTime? deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final String reportId;
  final String radiologistName;

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json["_id"] as String? ?? "",
      centerId: json["centerId"] as String? ?? "",
      radiologistId: json["radiologistId"] as String? ?? "",
      patientName: json["patient_name"] as String? ?? "Unknown",
      studyDate: DateTime.tryParse(json["study_date"] ?? ""),
      patientId: json["patient_id"] as String? ?? "",
      sex: json["sex"] as String? ?? "Unknown",
      modality: json["modality"] as String? ?? "",
      patientBirthDate: DateTime.tryParse(json["PatientBirthDate"] ?? ""),
      age: json["age"] as String? ?? "N/A",
      bodyPartExamined: json["body_part_examined"] as String? ?? "N/A",
      email: json["email"] as String? ?? "",
      dicomId: json["DicomId"] as String? ?? "",
      series: json["series"] as String? ?? "",
      status: json["status"] as String? ?? "Pending",
      deleted: json["deleted"] as bool? ?? false,
      dicomUrl: json["Dicom_url"] as String? ?? "",
      studyDescription: json["study_description"] as String? ?? "",
      deadline: DateTime.tryParse(json["deadline"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"] as int? ?? 0,
      reportId: json["reportId"] as String? ?? "",
      radiologistName: json["radiologistName"] as String? ?? "Unknown",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "centerId": centerId,
      "radiologistId": radiologistId,
      "patient_name": patientName,
      "study_date": studyDate?.toIso8601String(),
      "patient_id": patientId,
      "sex": sex,
      "modality": modality,
      "PatientBirthDate": patientBirthDate?.toIso8601String(),
      "age": age,
      "body_part_examined": bodyPartExamined,
      "email": email,
      "DicomId": dicomId,
      "series": series,
      "status": status,
      "deleted": deleted,
      "Dicom_url": dicomUrl,
      "study_description": studyDescription,
      "deadline": deadline?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
      "reportId": reportId,
      "radiologistName": radiologistName,
    };
  }
}
