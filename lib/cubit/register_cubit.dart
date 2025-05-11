import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/models/otp_model.dart';
import 'package:graduation_project_frontend/models/signup_model.dart';
import 'package:image_picker/image_picker.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.api) : super(RegisterInitial());
  bool isRegisterPasswordShowing = true;
  IconData suffixIcon = Icons.visibility_off;

  void changeRegisterPasswordSuffixIcon() {
    isRegisterPasswordShowing = !isRegisterPasswordShowing;
    suffixIcon =
        isRegisterPasswordShowing ? Icons.visibility : Icons.visibility_off;
    emit(ChangeRegisterPasswordSuffixIconState());
  }

  final ApiConsumer api;
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();

  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  Map<String, dynamic>? userdata;
  File? licenseImageFile;

  register(String selectedRole) async {
    emit(RegisterLoading());

    userdata = selectedRole == "Technician"
        ? {
            ApiKey.email: emailController.text,
            ApiKey.password: passwordController.text,
            ApiKey.contactNumber: contactNumberController.text,
            ApiKey.address: {
              "street": streetController.text,
              "city": cityController.text,
              "state": stateController.text,
              "zipCode": zipcodeController.text,
            },
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
          data: userdata);

      final signUpModel = SignUpModel.fromJson(response.data);
      if (signUpModel.message ==
          "OTP sent to email. Please verify to complete registration.") {
        print("hereee");
        print(licenseImageFile);
        emit(OtpVerfication(data: userdata!, message: signUpModel.message));
      } else {
        emit(RegisterFailure(error: signUpModel.message));
      }
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

       // تجهيز الصورة كـ MultipartFile
    MultipartFile? licenseImage;
    if (licenseImageFile != null) {
      licenseImage = await MultipartFile.fromFile(
        licenseImageFile!.path,
        filename: licenseImageFile!.path.split('/').last,
      );
    }

    // تجهيز البيانات كـ FormData
    FormData formData = FormData.fromMap({
      "path": licenseImage,
    });

      final response = await api.post(
        selectedRole == "Technician"
            ? EndPoints.VerifyOtpCenter(
                otp,
                userdata![ApiKey.email],
                userdata![ApiKey.password],
                userdata![ApiKey.centerName],
                userdata![ApiKey.contactNumber],
                userdata![ApiKey.address]["zipCode"],
                userdata![ApiKey.address]["street"],
                userdata![ApiKey.address]["city"],
                userdata![ApiKey.address]["state"])
            : EndPoints.VerifyOtpDoctor,
        isFromData: true,
        data:formData,
      );

      final otpModel = OtpModel.fromJson(response.data, selectedRole);

      if (otpModel.message == "The request has been sent successfully") {
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

  Future<void> pickLicenseImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      licenseImageFile = File(pickedFile.path);
      //  print("dinaa");
      //   print(licenseImageFile);
      // emit(ImagePickedSuccess(licenseImageFile!)); // لو عندك استيت مخصصة
      emit(LicenseImagePicked()); // دي حالة فاضية هنعرفها تحت
    }
  }
}
