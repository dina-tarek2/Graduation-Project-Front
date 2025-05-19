import 'package:graduation_project_frontend/models/doctors_model.dart';

class Centerdashboard {
    final int onlineRadiologists;
  final int totalRadiologists;
  final List<Doctor> onlineRadiologistsDetails;
  final int todayRecords;
  final int weeklyRecords;
  final int monthlyRecords;
  final Map<String, DailyReportStats> dailyStats;

  Centerdashboard({
  required this.onlineRadiologists, 
  required this.totalRadiologists,
   required this.onlineRadiologistsDetails,
    required this.todayRecords, 
    required this.weeklyRecords,
     required this.monthlyRecords, 
     required this.dailyStats});

}
class DailyReportStats {
  final int pending;
  final int reviewed;
  final int available;
  final int total;

  DailyReportStats({
    required this.pending,
    required this.reviewed,
    required this.available,
    required this.total,
  });
}