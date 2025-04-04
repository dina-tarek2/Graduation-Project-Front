import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/models/doctors_model.dart';

part 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final String id = 'doctor_profile_state';
  final DioConsumer dioConsumer;

  DoctorProfileCubit(this.dioConsumer) : super(DoctorProfileInitial());

  /// ✅ **جلب بيانات الطبيب**
  Future<void> fetchDoctorProfile(String doctorId) async {
    emit(DoctorProfileLoading());
    try {
      final response = await dioConsumer.get(
        'https://graduation-project-mmih.vercel.app/api/radiologists/getRadiologistById/$doctorId',
      );

      if (response != null && response.isNotEmpty) {
        final doctor = Doctor.fromJson(response);
        emit(DoctorProfileSuccess(doctor));
      } else {
        emit(DoctorProfileError("Faild get data ❌"));
      }
    } catch (e) {
      emit(
          DoctorProfileError("Faild ❌  ${e.toString()}"));
    }
  }

  /// ✅ **تحديث بيانات الطبيب باستخدام `PATCH`**
  Future<void> updateDoctorProfile(
      String doctorId, Map<String, dynamic> updates) async {
    emit(DoctorProfileLoading());
    try {
      print("the update:  + ${updates}");
      final response = await dioConsumer.patch(
        'https://graduation-project-mmih.vercel.app/api/radiologists/editRadiologist/$doctorId',
        data: updates, // ✅ الآن البيانات تُرسل بشكل صحيح
      );

      if (response != null) {
        print("✅done $response");
        await fetchDoctorProfile(doctorId); // ✅ تحديث البيانات بعد التعديل
      } else {
        emit(DoctorProfileError("❌ faild change the data"));
      }
    } catch (e) {
      emit(DoctorProfileError(
          "❌ Fiald: ${e.toString()}"));
    }
  }

  /// ✅ **تحديث صورة الملف الشخصي باستخدام `PATCH`**
  Future<void> updateProfileImage(String doctorId, String imagePath) async {
    emit(DoctorProfileLoading());
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imagePath),
      });

      print("📂 the req ${formData.fields.toString()}");

      final response = await dioConsumer.post(
        'https://graduation-project-mmih.vercel.app/api/radiologists/upload/$doctorId',
        data: formData, // ✅ إرسال `formData` بالكامل
      );

      if (response != null && response["statusCode"] == 200) {
        print("############# ");
        emit(Success("Change photo is successfly ✅"));
        await Future.delayed(Duration(seconds: 2));
        await fetchDoctorProfile(doctorId);
      } else {
        print("##################### ${response.toString()}");
        emit(DoctorProfileError("Change Photo is filed ❌"));
        await Future.delayed(Duration(seconds: 2));
        await fetchDoctorProfile(doctorId);
      }
    } catch (e) {
      emit(DoctorProfileError(
          "Change Photo is filed ❌${e.toString()}"));
    }
  }

  ///...
}
