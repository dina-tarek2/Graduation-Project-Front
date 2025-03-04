// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

String? Id;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.userRepository) : super(LoginInitial());
   final UserRepository userRepository;
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

  Future<void> login() async {
    emit(LoginLoading());
   final response = await userRepository.login(email: emailController.text,
    password: passwordController.text);
  // String errorMessage = response['message'] ?? 'An unknown error occurred.';  
  response.fold(
    (errorMassage){
    print("LoginError $errorMassage");
  
   emit(LoginError(errorMassage));
   },
    (SignInModel){emit(LoginSuccess(SignInModel.role));

  });
    }
 
  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
  class CenterCubit extends Cubit<String> {
  CenterCubit() : super('');

  void setCenterId(String id) {
    emit(id);
  }
}

