import 'package:graduation_project_frontend/models/reports_model.dart';

enum MedicalReportsStatus { initial, loading, success, error }

class MedicalReportsState {
  final List<Report> reports;
  final MedicalReportsStatus status;
  final String? errorMessage;
  final String? currentFilter;
   final int currentPage;
  final int totalReports;

  MedicalReportsState({
    this.reports = const [],
    this.status = MedicalReportsStatus.initial,
    this.errorMessage,
    this.currentFilter ,
     this.currentPage = 1,
    this.totalReports = 0,
  });

  MedicalReportsState copyWith({
    List<Report>? reports,
    MedicalReportsStatus? status,
    String? errorMessage,
    String? currentFilter,
    int? currentPage,
     int? totalReports,
  }) {
    return MedicalReportsState(
      reports: reports ?? this.reports,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentFilter: currentFilter ?? this.currentFilter,
       currentPage: currentPage ?? this.currentPage,
      totalReports: totalReports ?? this.totalReports,
    );
  }
}