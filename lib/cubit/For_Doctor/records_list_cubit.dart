import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:meta/meta.dart';

part 'records_list_state.dart';

class RecordsListCubit extends Cubit<RecordsListState> {
  RecordsListCubit(this.api) : super(RecordsListInitial());
  final TextEditingController bodyPartsController = TextEditingController();
  final ApiConsumer api;
  RecordsListModel? currentRecord;

  Future<void> fetchRecords(String id) async {
    emit(RecordsListLoading());
    try {
      final response = await api.get(EndPoints.GetRecordsByRadiologistId(id));
      if (response.data is List) {
        List<RecordsListModel> records = (response.data as List)
            .map((item) =>
                RecordsListModel.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(RecordsListSuccess(records));
      } else {
        throw Exception(
            "Unexpected response format: Expected a list but got something else");
      }
    } catch (e) {
      emit(RecordsListFailure(e.toString()));
    }
  }

  Future<void> getRecordById(String id) async {
    emit(RecordsListLoading());
    try {
      final response =
          await api.get('${EndPoints.baseUrl}Record/getOneRecordById/$id');

      if (response.data is Map<String, dynamic>) {
        print(
            'Response data: ${response.data}'); // طباعة البيانات للحصول على التفاصيل
        currentRecord = RecordsListModel.fromJson(response.data);
        bodyPartsController.text = currentRecord!.bodyPartExamined ?? "-";
        emit(RecordLoaded(currentRecord!));
        print("Record loaded successfully: ${response.data}");
      } else {
        throw Exception("Unexpected response format: Expected a map");
      }
    } catch (e) {
      print('Error: $e'); // طباعة الخطأ إذا حدث
      emit(RecordsListFailure(e.toString()));
    }
  }

  // apprpove api
  Future<void> approveRecord(String id) async {
    emit(RecordsListLoading());
    try {
      final response = await api.post(
        '${EndPoints.baseUrl}Record/approve/$id',
      );

      if (response.statusCode == 200) {
        print("Record approved successfully");

        emit(NewRecordSuccess());
      } else {
        throw Exception("Failed to approve record: ${response.statusCode}");
      }
    } catch (e) {
      print('Error approving record: $e');
      emit(RecordsListFailure(e.toString()));
    }
  }

  // cancel api
  Future<void> cancelRecord(String id) async {
    emit(RecordsListLoading());
    try {
      final response = await api.post(
        '${EndPoints.baseUrl}Record/cancel/$id',
      );
      if (response.statusCode == 200) {
        print("Record canceled successfully");
        emit(NewRecordSuccess());
      } else {
        throw Exception("Failed to cancel record: ${response.statusCode}");
      }
    } catch (e) {
      print('Error canceling record: $e');
      emit(RecordsListFailure(e.toString()));
    }
  }

  //extend deadline
  Future<void> extendDeadline(String recordId) async {
    try {
      final response = await api.post(
        EndPoints.extendDeadline(recordId),
      );

      if (response.statusCode == 200 &&
          response.data['message'] == "Study deadline extended by 1 hour") {
        print("deadline extended successfully");

        emit(ExtendedDeadlineSuccess());
      } else {
        throw Exception("Failed to extend record: ${response.statusCode}");
      }
    } catch (e) {
      print('Error extending record: $e');
      emit(RecordsListFailure(e.toString()));
    }
  }
}
