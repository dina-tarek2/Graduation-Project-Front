abstract class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class OtpVerfication extends RegisterState {
  final Map<String, dynamic> data;
  final String message;

  OtpVerfication({required this.message, required this.data});
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

class LicenseImagePicked extends RegisterState {}

class ChangeRegisterPasswordSuffixIconState extends RegisterState {}
