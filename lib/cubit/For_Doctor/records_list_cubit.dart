import 'package:bloc/bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:meta/meta.dart';

part 'records_list_state.dart';

class RecordsListCubit extends Cubit<RecordsListState> {
  RecordsListCubit(this.api) : super(RecordsListInitial());

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
}
