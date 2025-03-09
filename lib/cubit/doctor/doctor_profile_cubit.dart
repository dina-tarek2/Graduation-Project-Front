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
        emit(DoctorProfileError("❌ فشل تحميل بيانات الطبيب: استجابة فارغة"));
      }
    } catch (e) {
      emit(
          DoctorProfileError("❌ خطأ أثناء جلب بيانات الطبيب: ${e.toString()}"));
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
        print("✅ تم تحديث بيانات الطبيب بنجاح: $response");
        await fetchDoctorProfile(doctorId); // ✅ تحديث البيانات بعد التعديل
      } else {
        emit(DoctorProfileError("❌ فشل في تحديث بيانات الطبيب"));
      }
    } catch (e) {
      emit(DoctorProfileError(
          "❌ خطأ أثناء تحديث بيانات الطبيب: ${e.toString()}"));
    }
  }

  /// ✅ **تحديث صورة الملف الشخصي باستخدام `PATCH`**
  Future<void> updateProfileImage(String doctorId, String imagePath) async {
    emit(DoctorProfileLoading());
    try {
      FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(imagePath),
      });

      print("📂 the req ${formData.fields.toString()}");

      final response = await dioConsumer.post(
        'https://graduation-project-mmih.vercel.app/api/radiologists/upload/$doctorId',
        data: formData, // ✅ إرسال `formData` بالكامل
      );

      if (response != null ) {
        print("✅ تم تحديث صورة الملف الشخصي بنجاح: $response");
        await fetchDoctorProfile(doctorId);
      } else {
        emit(DoctorProfileError("❌ فشل في تحديث صورة الملف الشخصي"));
      }
    } catch (e) {
      emit(DoctorProfileError(
          "❌ خطأ أثناء تحديث صورة الملف الشخصي: ${e.toString()}"));
    }
  }

  ///...
}
