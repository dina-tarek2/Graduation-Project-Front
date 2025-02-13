// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/signIn_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
part 'login_state.dart';

String? Id;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this.api,
  ) : super(LoginInitial());
  final ApiConsumer api;
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoginPasswordShowing = true;
  IconData suffixIcon = Icons.visibility_off;

  void changeLoginPasswordSuffixIcon() {
    isLoginPasswordShowing = !isLoginPasswordShowing;
    suffixIcon =
        isLoginPasswordShowing ? Icons.visibility : Icons.visibility_off;
    emit(ChangeLoginPasswordSuffixIcon());
  }

  SignInModel? user;
  Future<void> login() async {
    // if (!loginKey.currentState!.validate()) return;
    try {
      emit(LoginLoading());
      final response = await api.post(
        EndPoints.SignIn,
        data: {
          ApiKey.email: emailController.text.trim(),
          ApiKey.password: passwordController.text.trim(),
        },
      );
      user = SignInModel.fromJson(response);
      
      final decodedToken = JwtDecoder.decode(user!.token);
      Id = decodedToken['id'];
      print(Id);
      emit(LoginSuccess(response));
    } on DioException catch (e) {
    String errorMessage = "An unexpected error occurred";

    if (e.response != null) {
      errorMessage = e.response!.data['message'] ?? errorMessage;
    
    }
    emit(LoginError(errorMessage));
  } catch (e) {
    emit(LoginError("Unexpected error: No radiology center found with this email"));
  }
  }
   @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
