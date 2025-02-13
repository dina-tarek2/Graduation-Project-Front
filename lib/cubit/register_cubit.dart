import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/models/otp_model.dart';
import 'package:graduation_project_frontend/models/signup_model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.api) : super(RegisterInitial());
  bool isRegisterPasswordShowing = true;
  IconData suffixIcon = Icons.visibility_off;

void changeRegisterPasswordSuffixIcon() {
  isRegisterPasswordShowing = !isRegisterPasswordShowing;
  suffixIcon = isRegisterPasswordShowing ? Icons.visibility : Icons.visibility_off;
  emit(ChangeRegisterPasswordSuffixIconState());
}

  final ApiConsumer api;
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  Map<String, dynamic>? userdata;

  

  register(String selectedRole) async {
    emit(RegisterLoading());

    userdata = selectedRole == "Technician"
          ? {
              ApiKey.email: emailController.text,
              ApiKey.password: passwordController.text,
              ApiKey.contactNumber: contactNumberController.text,
              ApiKey.address: addressController.text,
              ApiKey.centerName: centerNameController.text,
            }
          : {
              ApiKey.email: emailController.text,
              ApiKey.password: passwordController.text,
              ApiKey.contactNumber: contactNumberController.text,
              ApiKey.firstName: firstNameController.text,
              ApiKey.lastName: lastNameController.text,
              ApiKey.specialization: specializationController.text,
            };

    try {
      final response = await api.post(
        selectedRole == "Technician"
            ? EndPoints.SignUpCenter
            : EndPoints.SignUpDoctor,
        isFromData: false,
        data: userdata
      );

      final signUpModel = SignUpModel.fromJson(response);

      if (signUpModel.message ==
          "OTP sent to email. Please verify to complete registration.")
        emit(OtpVerfication(data: userdata!));
      else
        emit(RegisterFailure(error: signUpModel.message));
    } catch (error) {
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
      emit(RegisterFailure(error: "$error"));
      //handle in ui ??????
      // emit(RegisterFailure(error: response.data["message"]));
    }
  }



  Future<void> verifyOtp(String otp, String selectedRole) async {
    emit(OtpVerifying());

    try {
      if (userdata == null) {
        emit(RegisterFailure(error: "Registration data not found"));
        return;
      }

      final response = await api.post(
        selectedRole == "Technician" 
        ? EndPoints.VerifyOtpCenter 
        : EndPoints.VerifyOtpDoctor,
        isFromData: false,
        data: {
          ...userdata!,
          ApiKey.otp: otp,
        },
      );

      final otpModel = OtpModel.fromJson(response,selectedRole);

      if (otpModel.message == "Registration successful. You can now log in.") {
        emit(RegisterSuccess(userData: userdata!));
      } else {
        emit(RegisterFailure(error: "Invalid OTP"));
      }
    } catch (error) {
      // _handleError(error);
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
      emit(RegisterFailure(error: "$error"));
    }
  }

}
