
import 'package:dio/dio.dart';

abstract class RegisterState {}

final class RegisterInitial extends RegisterState {}
final class RegisterLoading extends RegisterState {}
final class RegisterSuccess extends RegisterState {
  final String userId;
  final String token;
  final String role;
  RegisterSuccess({required this.role,required this.token, required this.userId}); 
}
final class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});
}
// final class CompleteRegistrationSuccess extends RegisterState {}
