import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'forget_passeord_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ApiConsumer api;
  ForgetPasswordCubit(this.api) : super(ForgetPasswordInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> forgetPassword() async {
    try {
      emit(ForgetPasswordLoading());
      final response = await api.post(
        EndPoints.ForgetPassword,
        data: {ApiKey.email: emailController.text},
      );
      if (response.statusCode == 200) {
        emit(ForgetPasswordSuccess(response.data["message"]));
      } else {
        emit(ForgetPasswordFailure("Unexpected response format: $response"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }

  Future<void> checkOtp() async {
    final pref = await SharedPreferences.getInstance();
    final savedEmail = pref.getString('saved_email') ?? '';
    try {
      emit(ForgetPasswordLoading());
      final response = await api.post(
        EndPoints.CheckOtp,
        data: {
          ApiKey.email: savedEmail,
          ApiKey.otp: otpController.text,
        },
      );

      if (response.statusCode == 200) {
        emit(ForgetPasswordSuccess(response.data["message"]));
      } else {
        emit(ForgetPasswordFailure("Unexpected response format: $response"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }

  Future<void> ResetPassword() async {
    try {
      emit(ForgetPasswordLoading());
      final response = await api.post(
        EndPoints.ResetPassword,
        data: {
          ApiKey.email: emailController.text,
          ApiKey.newPassword: newPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        emit(ForgetPasswordReseted(response.data['message']));
      } else {
        emit(ForgetPasswordFailure("Unexpected response format: $response"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_email');
  }

  void updateOtp(String otp) {
    otpController.text = otp;
    emit(ForgetPasswordOtpUpdated(otp));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    return super.close();
  }
}
