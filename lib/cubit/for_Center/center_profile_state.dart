part of 'center_profile_cubit.dart';


abstract class CenterProfileState {}

class CenterProfileInitial extends CenterProfileState {}

class CenterProfileLoading extends CenterProfileState {}

class CenterProfileSuccess extends CenterProfileState {
  final Center0 center;
  CenterProfileSuccess(this.center);
}

class Success extends CenterProfileState {
  final String massege;
  Success(this.massege);
}

class CenterProfileError extends CenterProfileState {
  final String error;
  CenterProfileError(this.error);
}
