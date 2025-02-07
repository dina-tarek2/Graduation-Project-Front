part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic data;
  LoginSuccess(this.data);
}
class LoginDataSuccess extends LoginState {
  final String token;
  final Map<String, dynamic> radiologyCenter;

  LoginDataSuccess(this.token, this.radiologyCenter);
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
class ChangeLoginPasswordSuffixIcon extends LoginState {}
