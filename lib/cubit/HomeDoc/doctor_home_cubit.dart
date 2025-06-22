import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/models/centerDashboard_model.dart';
import 'package:graduation_project_frontend/models/centerRecord.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
    final ApiConsumer api;

  DoctorHomeCubit(this.api) : super(DoctorHomeInitial());
//  context.read<CenterCubit>().state;
Future<void> fetchDashboardData({required String doctorId,required String startDate,
  required String endDate, }) async {
    emit(DoctorHomeLoading());
   try {
    final dates = {
      "startDate": startDate,
      "endDate": endDate,
    };

    final avgRes = await api.post(
      'https://graduation-project-mmih.vercel.app/api/radiologistDashboard/getAverageTimeToCompleteReport/$doctorId',
      data: dates,
    );

    final avgTimeData = avgRes.data['averageTime'];
      int avgTime = 0;
      if (avgTimeData is int) {
        avgTime = avgTimeData;
      } else if (avgTimeData is double) {
        avgTime = avgTimeData.round();
      } else if (avgTimeData is String) {
        avgTime = int.tryParse(avgTimeData) ?? 0;
      }

    final statusRes = await api.post(
      'https://graduation-project-mmih.vercel.app/api/radiologistDashboard/getRecordsCountByStatus/$doctorId',
      data: dates,
    );
    
    final records = await api.post('https://graduation-project-mmih.vercel.app/api/radiologistDashboard/getRecordsCountForRadiologistInPeriod/$doctorId',
    data: dates,);

   final recordCount = records.data['recordCount'] ?? 0;


    final countByStatus = statusRes.data['countByStatus'] as Map<String, dynamic>;
   final count =statusRes.data['count'] ?? 0 ;

    Map<String, int> stats = {
      'Ready': countByStatus['Ready'] ?? 0,
      'Diagnose': countByStatus['Diagnose'] ?? 0,
      'Completed': countByStatus['Completed'] ?? 0,
    };
      final completedRecordsRes = await api.post(
  'https://graduation-project-mmih.vercel.app/api/radiologistDashboard/getAllCompletedRecordsbyradiologist/$doctorId',
  data: dates,
);

  final centersData = completedRecordsRes.data['centersWithCounts'];
      List<CenterRecord> centerRecords = [];
      
      if (centersData != null && centersData is List) {
        centerRecords = centersData
            .map((e) => CenterRecord.fromJson(e))
            .toList();
      }
final weeklyRes = await api.post(
  'https://graduation-project-mmih.vercel.app/api/radiologistDashboard/getWeeklyRecordsCountPerDayPerStatus/$doctorId',
  data: dates,
);

final weeklyList = weeklyRes.data['data'] ;

// final List<DailyStatusCount> weeklyStatusCounts = weeklyList
//     .map((e) => DailyStatusCount.fromJson(e))
//     .toList();

emit(DoctorHomeLoaded(
  avgTime: avgTime,
  stats: stats,
  recordCount: count,
  centerRecord: centerRecords,
  weeklyStatusCounts: weeklyList,
));

  } catch (e) {
    emit(DoctorHomeError(message: e.toString()));
  }
}



}

