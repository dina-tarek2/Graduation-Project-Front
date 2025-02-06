import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final Dio dio = Dio();
  //final String baseUrl = "https://graduation-project-mmih.vercel.app/api/auth/";

  Future<String?> registerUser(String email, String password, String role,
      String address, String contactNumber, String centerName) async {
    print("1");
    emit(RegisterLoading());
    print("2");
    print("here in api");
    print(email);
    print(password);
    print(centerName);
    print(contactNumber);
    try {
      final response = await dio.post(
        // "${baseUrl}registerRadiologyCenter",
        //"https://graduation-project-mmih.vercel.app/api/auth/registerRadiologyCenter",
        "https://graduation-project-mmih.vercel.app/api/auth/registerRadiologyCenter",
        data: {
          "centerName": centerName,  
          "address": address,
          "contactNumber": contactNumber,
          "email": email,
          "password": password,
        },
      );
      print("3");
      print(response);
      print("dinatarekkkkkkkkkkkkk${response.data}");

      if (response.statusCode == 201) {
        final data = response.data;
        final String token = data["token"];
        final String userId = data["radiologyCenter"]["_id"];
        // print("dinaaaatarekkk");
        // print("Dataaaaaaaaaa${data}");
        // print("idddddd${userId}");

        emit(RegisterSuccess(userId: userId, role: role, token: token));
        return userId;
      } else {
        emit(RegisterFailure(error: response.data["message"] ?? " "));
        return null;
      }
    } catch (error) {
      // print("Network Error: $error");
       if (error is DioException) {
    print("DioException Error: ${error.message}");
    print("DioException Response: ${error.response?.data}");
    print("DioException Status Code: ${error.response?.statusCode}");
  } else {
    print("Unknown Error: $error");
  }
  
      emit(RegisterFailure(error: "$error"));
      return null;
    }
  }

  Future<String?> registerDoctor(String email, String password, String role,
      String specialization, String contactNumber, String firstName, String lastName) async {
    
    emit(RegisterLoading());
    
    // print("here in api");
    // print(email);
    // print(password);
    // print(contactNumber);
    try {
      final response = await dio.post(
        "https://graduation-project-mmih.vercel.app/api/RadiologistAuth/registerRadiologist",
        data: {
          "firstName": firstName,  
          "lastName": lastName,
          "specialization": specialization,
          "contactNumber": contactNumber,
          "email": email,
          "password": password,
        },
      );
     // print("3");
      print(response);
      print("dinatarekkkkkkkkkkkkk${response.data}");

      if (response.statusCode == 201) {
        final data = response.data;
        final String token = data["token"];
        final String userId = data["radiologist"]["_id"];
        // print("Dataaaaaaaaaa${data}");
        // print("idddddd${userId}");

        emit(RegisterSuccess(userId: userId, role: role, token: token));
        return userId;
      } else {
        emit(RegisterFailure(error: response.data["message"] ?? " "));
        return null;
      }
    } catch (error) {
      // print("Network Error: $error");
       if (error is DioException) {
    print("DioException Error: ${error.message}");
    print("DioException Response: ${error.response?.data}");
    print("DioException Status Code: ${error.response?.statusCode}");
  } else {
    print("Unknown Error: $error");
  }
  
      emit(RegisterFailure(error: "$error"));
      return null;
    }
  }
}
