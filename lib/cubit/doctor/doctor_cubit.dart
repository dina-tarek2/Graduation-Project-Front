
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
      if (response.statusCode==200) {
        List<dynamic> doctorJson =  response.data["data"]["radiologists"] ?? [];
          doctors =
              doctorJson.map((json) => Doctor.fromJson(json)).toList();
          emit(DoctorListSuccess(doctors));
      }else {
        emit(DoctorListError("Invalid response format."));
      }
    } catch (e) {
      print("Error fetching doctors: ${e.toString()}");
      emit(DoctorListError("Error fetching doctors: ${e.toString()}"));
    }
  }
Future<void>AddDoctor(String DoctorId, String centerId)async{
try {
   final response =await api.post('https://graduation-project-mmih.vercel.app/api/relations/radiologists/$centerId'
   ,data: {'radiologistId':DoctorId});
   if (response.statusCode ==201) {
    await fetchDoctors(centerId);
      // final newDoctor = Doctor.fromJson(response.data['data']);
      // doctors.add(newDoctor);
      // emit(DoctorListSuccess(List.from(doctors)));
     emit( DoctorAddedSuccess("the Doctor Added Successfuly"));
   }else{
    emit(DoctorListError("Failed to Add doctor"));
   }
} catch (e) {
   print("Error adding doctor: ${e.toString()}");
      emit(DoctorListError("Error adding doctor: ${e.toString()}"));
    }
}
Future<void>AddDoctorByEmail(String email, String centerId)async{
try {
   final response =await api.post('https://graduation-project-mmih.vercel.app/api/relations/radiologist/$centerId'
   ,data: {'email':email});
   if (response.statusCode ==201) {
    await fetchDoctors(centerId);
      // final newDoctor = Doctor.fromJson(response.data['data']);
      // doctors.add(newDoctor);
      // emit(DoctorListSuccess(List.from(doctors)));
     emit( DoctorAddedSuccess("the Doctor Added Successfuly"));
   }else if(response.statusCode == 404){
    emit(DoctorListError("This doctor does not exist. An invitation has been sent"));
   }
   else if(response.statusCode == 409){
    emit(DoctorListError("Radiologist is already assigned to this center"));
   }
   else{
    emit(DoctorListError("Failed to Add doctor"));
   }
} catch (e) {
   print("Error adding doctor: ${e.toString()}");
      emit(DoctorListError("Error adding doctor: ${e.toString()}"));
    }
}
Future<void>SendDocInvitation(String email, String centerId)async{
try {
   final response =await api.post('https://graduation-project-mmih.vercel.app/api/relations/sendEmailToRadiologist/$centerId'
   ,data: {'email':email});
   if (response.statusCode ==202) {
    await fetchDoctors(centerId);
      // final newDoctor = Doctor.fromJson(response.data['data']);
      // doctors.add(newDoctor);
      // emit(DoctorListSuccess(List.from(doctors)));
     emit( DoctorAddedSuccess("Invitation email sent successfully"));
   }
   else{
    emit(DoctorListError("Failed to Add doctor"));
   }
} catch (e) {
   print(" ${e.toString()}");
      emit(DoctorListError("Error adding doctor: ${e.toString()}"));
    }
}
Future deleteDoctors(String id, String centerId) async {
  try {
    final response = await api.delete(
      'https://graduation-project-mmih.vercel.app/api/relations/removeRadiologistFromCenter/$centerId',
    data:{'radiologistId':id});

    if (response.statusCode == 200) {
       emit( DoctorDeletedSuccess("The Doctor is Deleted Successfuly"));
      await fetchDoctors(centerId);
    } else {
      emit(DoctorListError("Failed to delete doctor"));
    }
  } catch (e) {
    print("Error deleting doctor: ${e.toString()}");
    
    emit(DoctorListError("Error deleting doctor: ${e.toString()}"));
  }
}
}