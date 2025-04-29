import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Admin/docotors_model.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this.api) : super(DoctorsInitial());
    final ApiConsumer api;

     Future<void> fetchDoctors() async {
    try {
      emit(DoctorsLoading());
      final response = await api.get(EndPoints.getDoctorsByAdmin);

      final doctorModel = DocotorsModel.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(DoctorsSuccess(doctors: doctorModel.data));
      }
    } on DioException catch (e) {
      print("DioException Error: ${e.message}");
      print("DioException Response: ${e.response?.data}");
      print("DioException Status Code: ${e.response?.statusCode}");

      emit(DoctorsFailure(error: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      print("Unknown Error: $e");
      emit(DoctorsFailure(error: "$e"));
    }
  }
    
}
