import 'package:bloc/bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:meta/meta.dart';

part 'records_list_state.dart';

class RecordsListCubit extends Cubit<RecordsListState> {
  RecordsListCubit(this.api) : super(RecordsListInitial());

  final ApiConsumer api;

  Future<void> fetchRecords() async {
    emit(RecordsListLoading());
    try {
      final response = await api.get(EndPoints.GetRecordsByRadiologistId);

      print("Response received: $response");

      if (response is List) {
        print("List received successfully");

        List<RecordsListModel> records = response
            .cast<
                Map<String,
                    dynamic>>() // check data is a Map<String, dynamic>
            .map((e) => RecordsListModel.fromJson(e))
            .toList();

        emit(RecordsListSuccess(records));
      } else {
        throw Exception(
            "Unexpected response format: Expected a list but got something else");
      }
    } catch (e) {
      print("Error fetching records: $e");
      emit(RecordsListFailure(e.toString()));
    }
  }
}
