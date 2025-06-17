import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/DashboardCenter/medical_dashboard_state.dart';
import 'package:graduation_project_frontend/repositories/medical_repository.dart';
import 'package:intl/intl.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final centerDashboardRepository repository;
  
  DashboardCubit({required this.repository}) : super(DashboardInitial());
  
  Future<void> loadDashboard(DateTime startDate, DateTime endDate, ) async {
    try {
      emit(DashboardLoading(0.0));
       final String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
      
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: 200));
        emit(DashboardLoading(i / 10));
      }
      
      final data = await repository.fetchDashboardData(startDate: formattedStartDate, endDate: formattedEndDate);
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }


}
