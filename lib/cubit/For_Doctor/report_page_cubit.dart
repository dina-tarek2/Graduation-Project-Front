import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/models/Doctor/report_page_model.dart';

part 'report_page_state.dart';

class ReportPageCubit extends Cubit<ReportPageState> {
  ReportPageCubit(this.api) : super(ReportPageInitial());

  final ApiConsumer api;

  final TextEditingController impressionController = TextEditingController();
  final TextEditingController findingsController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController resultController = TextEditingController();

  Future<void> fetchReport(String reportId) async {
    emit(ReportPageLoading());

    try {
      final response = await api.get(
          "https://graduation-project-mmih.vercel.app/api/AIReports/getOneAIReport/$reportId");

      final reportModel = ReportModel.fromJson(response.data);

      if (reportModel.error == null) {
        impressionController.text = reportModel.diagnosisReportImpression;
        findingsController.text = reportModel.diagnosisReportFinding;
        commentsController.text = reportModel.diagnosisReportComment;
        resultController.text = reportModel.result;
        emit(ReportPageSuccess(report: reportModel));
      } else {
        emit(ReportPageFailure(errmessage: reportModel.error!));
      }
    } on DioException catch (e) {
      emit(ReportPageFailure(errmessage: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      emit(ReportPageFailure(errmessage: "$e"));
      // emit(RegisterFailure(error: response.data["message"]));
    }
  }

  Future<void> updateReportOrRecord({
    required String id,
    required bool isReport,
    required Map<String, dynamic> body,
  }) async {
    final url = isReport
        ? 'https://graduation-project-mmih.vercel.app/api/AIReports/updateAIReport/$id'
        : 'https://graduation-project-mmih.vercel.app/api/Record/updateRecordById/$id';

    try {
      await api.put(url, data: body);
    } catch (e) {}
  }
}
