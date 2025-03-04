import 'package:bloc/bloc.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_state.dart';
import 'package:graduation_project_frontend/models/reports_model.dart';
import 'package:graduation_project_frontend/repositories/medical_repository.dart';

class MedicalReportsCubit extends Cubit<MedicalReportsState> {
   final MedicalRepository repository;
   List<Report> allReports = [];
    MedicalReportsCubit({required this.repository}) : 
    super(MedicalReportsState(currentFilter: 'all'));

Future<void> fetchReports() async {
    emit(state.copyWith(status: MedicalReportsStatus.loading));
    
    try {
      final reportsResponse = await repository.getAllReports();

      final patientNames = await Future.wait(
        reportsResponse.reports.map((report) async {  
          try{
      return await repository.getPatientName(report.recordId);  
          }catch(e){
          return e.toString() ;
          }
    }));  

    for (int i = 0; i < reportsResponse.reports.length; i++) {  
      reportsResponse.reports[i].patientName = patientNames[i];  
    }  
      allReports = reportsResponse.reports;
      emit(state.copyWith(
        reports: filterReports(allReports, state.currentFilter ?? 'all'),
        totalReports: reportsResponse.numOfAIReports,
        status: MedicalReportsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MedicalReportsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  List<Report> get filteredReports {
    return state.reports.where((report) {
      switch (state.currentFilter) {
        case 'available':
          return report.status == 'Available';
          case 'pending':
          return report.status == 'Pending';
        default:
          return true;
      }
    }).toList();
  }

   void filterReportss(String filter) {
    emit(state.copyWith(
      currentFilter: filter,
      reports: filterReports(allReports, filter),
    ));
  }
    List<Report> filterReports(List<Report> reports, String filter) {
    switch (filter) {
      case 'pending':
        return reports.where((report) => report.status == 'Pending').toList();
      case 'Reviewed':
        return reports.where((report) => report.status == 'Reviewed').toList();
      case 'all':
      default:
        return reports;
    }
  }
  void searchReports(String query) {
  if (query.isEmpty) {
    filterReportss(state.currentFilter ?? 'all');
    return;
  }
  
  final filteredReports = allReports.where((report) {
    return report.patientName?.toLowerCase().contains(query.toLowerCase()) ?? false ||
              report.confidenceLevel.toString().contains(query.toString()) ||  
            report.recordId.toString().contains(query.toString()) ;
  }).toList();
  
  emit(state.copyWith(reports: filteredReports));
}

  void refresh() {
  emit(state.copyWith(status: MedicalReportsStatus.loading));
    fetchReports();
  }
}

  



