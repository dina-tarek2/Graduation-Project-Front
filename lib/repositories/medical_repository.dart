import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/models/centerDashboard_model.dart';
import 'package:graduation_project_frontend/models/doctors_model.dart';
import 'package:graduation_project_frontend/models/patient_model.dart';
import 'package:graduation_project_frontend/models/reports_model.dart';
import 'package:intl/intl.dart';

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
  class centerDashboardRepository {
  final ApiConsumer api;
    final String centerId;
  centerDashboardRepository(this.api, this.centerId);

  Future<Centerdashboard> fetchDashboardData( {required String startDate,  // تغيير من DateTime إلى String
    required String endDate,}  ) async {
    try {
       final now = DateTime.now();
      // final endDate = DateFormat('yyyy-MM-dd').format(now);
      // final startDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 6)));
     
    

final rangeRecordsCountResponse = await api.post(
        'https://graduation-project-mmih.vercel.app/api/dashboard/getrangeRecordsCount/${centerId}',
        data: {
          'startDate': startDate ,
          'endDate': endDate ,
        }
      );
       final recordsCountResponse = await api.get(
        'https://graduation-project-mmih.vercel.app/api/dashboard/getRecordsCountPerDayInCenter/$centerId'
      ); 
        final centerResponse = await api.get(
        'https://graduation-project-mmih.vercel.app/api/dashboard/getCenterStatistics/$centerId'
      );
      final centerData = centerResponse.data['data'];
      final onlineRadiologists = centerData['onlineRadiologists'] ;
      final totalRadiologists = centerData['totalRadiologists'] ;
       final onlineRadiologistsDetails = (centerData['onlineRadiologistsDetails'] as List)
          .map((radiologist) => Doctor(
                id: radiologist['_id'],
                firstName: radiologist['firstName'],
                lastName: radiologist['lastName'],
                specialization: List<String>.from(radiologist['specialization']),
                contactNumber: radiologist['contactNumber'],
                status: radiologist['status'],
                email: radiologist['email'],
                imageUrl: radiologist['image'],
                experience: radiologist['experience'],
                numberOfReports: _parseNumberOfReports(radiologist['numberOfReports']),
              ))
          .toList();
          // Parse records count per day
      final recordsData = recordsCountResponse.data['data'];
      final todayRecords = recordsData['today'] as int;
      final weeklyRecords = recordsData['thisWeek'] as int;
      final monthlyRecords = recordsData['thisMonth'] as int;
 // Parse range records count
      final rangeData = rangeRecordsCountResponse.data['data'];
      final dailyStats = <String, DailyReportStats>{};
      rangeData.forEach((day, stats) {
        dailyStats[day] = DailyReportStats(
          Diagnose: stats['Diagnose'] as int,
          Completed: stats['Completed'] as int,
          Ready: stats['Ready'] as int,
          total: stats['total'] as int,
        );
      });

      return Centerdashboard(
        onlineRadiologists: onlineRadiologists,
        totalRadiologists: totalRadiologists,
        onlineRadiologistsDetails: onlineRadiologistsDetails,
        todayRecords: todayRecords,
        weeklyRecords: weeklyRecords,
        monthlyRecords: monthlyRecords,
        dailyStats: dailyStats,
      );
    } catch (e) {
      print('Error fetching dashboard data: $e');
      throw Exception('Failed to load dashboard data: $e');
    }
  }
 Map<String, List<String>> _parseNumberOfReports(Map<String, dynamic> reports) {
    final result = <String, List<String>>{};
    reports.forEach((key, value) {
      result[key] = List<String>.from(value);
    });
    return result;
  }
}

