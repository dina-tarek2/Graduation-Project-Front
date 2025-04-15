import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Admin/approved_centers_model.dart';

part 'manage_centers_state.dart';

class ManageCentersCubit extends Cubit<ManageCentersState> {
  ManageCentersCubit(this.api) : super(ManageCentersInitial());

  final ApiConsumer api;

  Future<void> fetchApprovedCenters() async {
    try {
      emit(ManageCentersLoading());
      final response = await api.get(EndPoints.getApprovedCenters);

      final approvedcenterModel = ApprovedCentersModel.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(ManageCentersSuccess(centers: approvedcenterModel.data));
        print("okkkk");
      }
    } on DioException catch (e) {
      print("DioException Error: ${e.message}");
      print("DioException Response: ${e.response?.data}");
      print("DioException Status Code: ${e.response?.statusCode}");

      emit(ManageCentersFailure(error: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      print("Unknown Error: $e");
      emit(ManageCentersFailure(error: "$e"));
      // emit(RegisterFailure(error: response.data["message"]));
    }
  }
}
