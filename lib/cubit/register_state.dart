import 'package:dio/dio.dart';

abstract class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class OtpVerfication extends RegisterState {
  final Map<String, dynamic> data;

  OtpVerfication({required this.data});
}

class OtpVerifying extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> userData;

  RegisterSuccess({required this.userData});
}

final class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});
}
class ChangeRegisterPasswordSuffixIconState extends RegisterState {}
