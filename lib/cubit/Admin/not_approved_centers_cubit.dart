import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Admin/approved_centers_model.dart';

part 'not_approved_centers_state.dart';

class NotApprovedCentersCubit extends Cubit<NotApprovedCentersState> {
  NotApprovedCentersCubit(this.api) : super(NotApprovedCentersInitial());

  ApiConsumer api;

  Future<void> fetchAllCenters() async {
    emit(NotApprovedCentersLoading());

    try {
      final response = await api.get(EndPoints.getNotApprovedCenters);

      final notApprovedCentersModel =
          ApprovedCentersModel.fromJson(response.data);

      if (response.statusCode == 200) {
        emit(NotApprovedCentersSuccess(centers: notApprovedCentersModel.data));
        print("hereeee");
      }
    } catch (error) {
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
      emit(NotApprovedCentersFailure(error: "$error"));
    }
  }

  Future<void> getCenterInfo(String centerId) async {
    emit(centerInfoLoading());

    try {
      final response = await api.get(EndPoints.getCenterInfoByAdmin(centerId));

      final centerModel = Datum.fromJson(response.data["data"]);

      if (response.statusCode == 200) {
        emit(centerInfoSuccess(center: centerModel));
      }
    } catch (error) {
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
      emit(centerInfoFailure(error: "$error"));
    }
  }

  Future<void> approveCenter(String centerId) async {
    emit(adminApprovedCenterLoading());
    try {
  final response = await api.post(EndPoints.approveCenterAdmin(centerId));
  
  if (response.statusCode == 200) {
    emit(adminApprovedCenterSuccessfully());
    // await fetchAllCenters();
  }
} catch (error) {
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
      emit(adminApprovedCenterFailure(error: "$error"));
    }
  }
}
