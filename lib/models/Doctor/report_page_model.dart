class ReportModel {
  final String id;
  final String recordId;
  final String centerId;
  final String radiologistId;
  final String diagnosisReportFinding;
  final String diagnosisReportImpression;
  final String diagnosisReportComment;
  final String result;
  final double confidenceLevel;
  final bool deleted;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? error;

  ReportModel({
    required this.id,
    required this.recordId,
    required this.centerId,
    required this.radiologistId,
    required this.diagnosisReportFinding,
    required this.diagnosisReportImpression,
    required this.diagnosisReportComment,
    required this.result,
    required this.confidenceLevel,
    required this.deleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.error,
  });

  // تحويل من JSON إلى كائن Dart
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['_id'],
      recordId: json['record'],
      centerId: json['centerId'],
      radiologistId: json['radiologistID'],
      diagnosisReportFinding: json['diagnosisReportFinding'],
      diagnosisReportImpression: json['diagnosisReportImpration'], //?
      diagnosisReportComment: json['diagnosisReportComment'],
      result: json['result'],
      confidenceLevel: (json['confidenceLevel'] as num).toDouble(),
      deleted: json['deleted'],
      version: json['version'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      error: json['error'],
    );
  }

  // تحويل كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'record': recordId,
      'centerId': centerId,
      'radiologistID': radiologistId,
      'diagnosisReportFinding': diagnosisReportFinding,
      'diagnosisReportImpration': diagnosisReportImpression,
      'diagnosisReportComment': diagnosisReportComment,
      'result': result,
      'confidenceLevel': confidenceLevel,
      'deleted': deleted,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
