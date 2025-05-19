import 'package:bloc/bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';

part 'uploaded_dicoms_state.dart';

class UploadedDicomsCubit extends Cubit<UploadedDicomsState> {
  UploadedDicomsCubit(this.api) : super(UploadedDicomsInitial());

  final ApiConsumer api;

  Future<void> fetchUploadedDicoms(String centerid) async {
    emit(UploadedDicomsLoading());
    try {
      final response = await api.get(EndPoints.GetRecordsByCenterId(centerid));

      print("Response received: ${response.data}");

      if (response.data != null && response.data is Map<String, dynamic>) {
        print("Valid response format");

        // تحويل الـ JSON إلى Model
        UploadedDicomModel dicomsModel =
            UploadedDicomModel.fromJson(response.data);
        emit(UploadedDicomsSuccess(dicomsModel.records));
      } else {
        throw Exception(
            "Unexpected response format: Expected a Map<String, dynamic> but got something else");
      }
    } catch (e) {
      print("Error fetching uploaded DICOMs: ${e.toString()}");
      emit(UploadedDicomsFailure(e.toString()));
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
      print("Error reassigning cancled records: ${e.toString()}");
      emit(ReassignFailure(e.toString()));
    }
  }
}
