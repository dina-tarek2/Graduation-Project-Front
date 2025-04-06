part of 'forget_passeord_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}
final class ForgetPasswordLoading extends ForgetPasswordState {}
final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String massage ;
  ForgetPasswordSuccess(this.massage);
}
final class ForgetPasswordFailure extends ForgetPasswordState {
   final String error ;
  ForgetPasswordFailure(this.error);
}
final class ForgetPasswordOtpUpdated extends ForgetPasswordState {
   final String otp ;
  ForgetPasswordOtpUpdated(this.otp);
}
