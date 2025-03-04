
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/doctors_model.dart';

part 'doctor_state.dart' ;
class DoctorCubit extends Cubit<DoctorListState> {
  DoctorCubit(this.api) : super(DoctorListInitial());
  final ApiConsumer api ;
  List<Doctor> doctors = [];
  Future<void> fetchDoctors(String centerId) async {
    try {
      final response = await api.get(
        EndPoints.getCenterId(centerId)
      );
      if (response is Map && response.containsKey("data")) {
        List<dynamic> doctorJson = response["data"]["radiologists"] ?? [];
       if (doctorJson.isNotEmpty) {
          doctors =
              doctorJson.map((json) => Doctor.fromJson(json)).toList();
          emit(DoctorListSuccess(doctors));
      }else {
        emit(DoctorListError("Failed to fetch doctors"));
      }
      }else {
        emit(DoctorListError("Invalid response format."));
      }
    } catch (e) {
      print("Error fetching doctors: ${e.toString()}");
      emit(DoctorListError("Error fetching doctors: ${e.toString()}"));
    }
  }
Future<void>AddDoctor(String DoctorId, String centerId)async{
  emit(DoctorListLoading());
try {
   final response =await api.post('https://graduation-project-mmih.vercel.app/api/relations/radiologists/$centerId'
   ,data: {'radiologistId':DoctorId});
   if (response is Map &&response.containsKey('data')) {
    await fetchDoctors(centerId);
      final newDoctor = Doctor.fromJson(response['data']);
      doctors.add(newDoctor);
      emit(DoctorListSuccess(List.from(doctors)));
   }
} catch (e) {
   print("Error adding doctor: ${e.toString()}");
      emit(DoctorListError("Error adding doctor: ${e.toString()}"));
    }
}
void deleteDoctors(int index){
   doctors.removeAt(index);
  emit(DoctorListSuccess(doctors));
}
}
 