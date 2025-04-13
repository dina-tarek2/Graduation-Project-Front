import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/models/Doctor/report_page_model.dart';
import 'package:graduation_project_frontend/models/reports_model.dart';

part 'report_page_state.dart';

class ReportPageCubit extends Cubit<ReportPageState> {
  ReportPageCubit(this.api) : super(ReportPageInitial());

  final ApiConsumer api;

  final TextEditingController impressionController = TextEditingController();
  final TextEditingController findingsController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController recommendationsController =
      TextEditingController();

  Future<void> fetchReport(String reportId) async {
    emit(ReportPageLoading());

    try {
      final response = await api.post(
        EndPoints.
        analyzeImage
        (reportId), data: {
        "imageUrl":
            "https://www.aleqt.com/sites/default/files/a/506265_149401.jpg"
      });

      final reportModel = ReportModel.fromJson(response.data);

      if (reportModel.error == null) {
        impressionController.text = reportModel.diagnosisReportImpression ?? "";
        findingsController.text = reportModel.diagnosisReportFinding ?? "";
        commentsController.text = reportModel.diagnosisReportComment ?? "";
        recommendationsController.text = "???????";
        emit(ReportPageSuccess(report: reportModel));
      } else {
        emit(ReportPageFailure(errmessage: reportModel.error!));
      }
    } on DioException catch (e) {
      print("DioException Error: ${e.message}");
      print("DioException Response: ${e.response?.data}");
      print("DioException Status Code: ${e.response?.statusCode}");

      emit(ReportPageFailure(errmessage: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      print("Unknown Error: $e");
      emit(ReportPageFailure(errmessage: "$e"));
      // emit(RegisterFailure(error: response.data["message"]));
    }
  }
}
