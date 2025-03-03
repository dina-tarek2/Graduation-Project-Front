import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/patient_model.dart';
import 'package:graduation_project_frontend/models/reports_model.dart';

class MedicalRepository {
    final ApiConsumer api;

  MedicalRepository({required this.api});
  

 Future<ReportsResponse> getAllReports() async {
    try {
      final response = await api.get('https://graduation-project-mmih.vercel.app/api/AIReports/getAllAIReports');
      if (response is Map<String, dynamic>) {  
      return ReportsResponse.fromJson(response);  
    } else if (response is! Map<String, dynamic> && response.data != null) {
      return ReportsResponse.fromJson(response.data);  
    } else {
      throw Exception('Unexpected Data Format');  
    }
    } catch (e) {  
      throw Exception('Failed to fetch reports: $e');  
    }  
  }  
 
  Future<String> getPatientName(String recordId) async {
    try {
      final response = await api.get('https://graduation-project-mmih.vercel.app/api/Record/getRecordById/$recordId');
     if (response is Map<String, dynamic>) {  
      final patientResponse = Patient.fromJson(response);
      return patientResponse.patientName;
    } else if (response is! Map<String, dynamic> && response.data != null) {
      final patientResponse = Patient.fromJson(response.data);
      return patientResponse.patientName;
    } else {  
      throw Exception('Unexpected Data Format');  
    }
    } catch (e) {
      throw Exception('Failed to fetch patient name: $e');
    }
  }
}
  