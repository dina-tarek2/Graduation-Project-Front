part of 'doctor_profile_cubit.dart';

abstract class DoctorProfileState {}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileSuccess extends DoctorProfileState {
  final Doctor doctor;
    DoctorProfileSuccess(this.doctor);
}

class DoctorProfileError extends DoctorProfileState {
  final String error;
  DoctorProfileError(this.error);
}
