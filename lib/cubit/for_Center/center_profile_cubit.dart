import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:radintel/api_services/dio_consumer.dart';
import 'package:radintel/models/centers_model.dart';

part 'center_profile_state.dart';

class CenterProfileCubit extends Cubit<CenterProfileState> {
  final String id = 'doctor_profile_state';
  final DioConsumer dioConsumer;

  CenterProfileCubit(this.dioConsumer) : super(CenterProfileInitial());

  /// ✅ **جلب بيانات الطبيب**
  Future<void> fetchCenterProfile(String centerId) async {
    emit(CenterProfileLoading());
    try {
      final response = await dioConsumer.get(
        'https://graduation-project-mmih.vercel.app/api/centers/getCenterById/$centerId',
      );
      if (response.data != null && response.data.isNotEmpty) {
        final center = Center0.fromJson(response.data['data']);
        emit(CenterProfileSuccess(center));
        print("ccccccccccccc ${center.centerName}");
      } else {
        emit(CenterProfileError("Faild get data ❌"));
      }
    } catch (e) {
      emit(CenterProfileError("Faild ❌  ${e.toString()}"));
    }
  }

  /// ✅ **تحديث بيانات الطبيب باستخدام `PATCH`**
  Future<void> updateCenterProfile(
      String centerId, Map<String, dynamic> updates) async {
    emit(CenterProfileLoading());
    try {
      print("the update:  + ${updates}");
      final response = await dioConsumer.put(
        'https://graduation-project-mmih.vercel.app/api/admin/updateRadiologyCenter/$centerId',
        data: updates, // ✅ الآن البيانات تُرسل بشكل صحيح
      );

      if (response.data != null) {
        print("✅done $response");
        await fetchCenterProfile(centerId); // ✅ تحديث البيانات بعد التعديل
      } else {
        emit(CenterProfileError("❌ faild change the data"));
      }
    } catch (e) {
      emit(CenterProfileError("❌ Fiald: ${e.toString()}"));
    }
  }

  /// ✅ **تحديث صورة الملف الشخصي باستخدام `PATCH`**
  Future<void> updateProfileImage(String centerId, String imagePath) async {
    emit(CenterProfileLoading());
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imagePath),
      });

      print("📂 the req ${formData.fields.toString()}");

      final response = await dioConsumer.post(
        'https://graduation-project-mmih.vercel.app/api/radiologists/upload/$centerId',
        data: formData, // ✅ إرسال `formData` بالكامل
      );

      if (response.data != null && response.data["statusCode"] == 200) {
        print("############# ");
        emit(Success("Change photo is successfly ✅"));
        await Future.delayed(Duration(seconds: 2));
        await fetchCenterProfile(centerId);
      } else {
        print("##################### ${response.toString()}");
        emit(CenterProfileError("Change Photo is filed ❌"));
        await Future.delayed(Duration(seconds: 2));
        await fetchCenterProfile(centerId);
      }
    } catch (e) {
      emit(CenterProfileError("Change Photo is filed ❌${e.toString()}"));
    }
  }

  ///...
}
