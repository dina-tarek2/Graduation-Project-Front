import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
part 'uploaded_dicoms_state.dart';

class UploadedDicomsCubit extends Cubit<UploadedDicomsState> {
  UploadedDicomsCubit(this.api) : super(UploadedDicomsInitial());

  final ApiConsumer api;

  Future<void> fetchUploadedDicoms(String centerid) async {
    emit(UploadedDicomsLoading());
    try {
      final response = await api.get(EndPoints.GetRecordsByCenterId(centerid));

      if (response.data != null && response.data is Map<String, dynamic>) {
        UploadedDicomModel dicomsModel =
            UploadedDicomModel.fromJson(response.data);
        emit(UploadedDicomsSuccess(dicomsModel.records));
      } else {
        throw Exception(
            "Unexpected response format: Expected a Map<String, dynamic> but got something else");
      }
    } catch (e) {
      emit(UploadedDicomsFailure(e.toString()));
    }
  }

  Future<void> updateDicomflag(BuildContext context, String dicomId,
      Map<String, dynamic> updates) async {
    // ⬅️ Step 1: Emit loading state
    try {
      final response = await api.post(
        '${EndPoints.baseUrl}Record/toggleFlag/$dicomId',
        data: updates,
      ); // ⬅️ Step 2: Send request

      if (response.data != null && response.data is Map<String, dynamic>) {
        final message = response.data["message"] ?? "Flag updated successfully";
        showAdvancedNotification(
          // ignore: use_build_context_synchronously
          context,
          message: message,
          type: NotificationType.success,
        );
      } else {
        throw Exception(
            "Unexpected response format: Expected a Map<String, dynamic>");
      }
    } catch (e) {
      showAdvancedNotification(
        // ignore: use_build_context_synchronously
        context,
        message: e.toString(),
        type: NotificationType.error,
      ); // ⬅️ Step 4: Emit failure
    }
  }

  Future<void> reassign(String recordId) async {
    try {
      final response =
          await api.post(EndPoints.RedirectToDoctorFromRadintal(recordId));

      if (response.statusCode == 200 &&
          response.data['message'] == "Record redirected successfully") {
        emit((ReassignedSuccessfully()));
      }
    } on Exception catch (e) {
      emit(ReassignFailure(e.toString()));
    }
  }
}
