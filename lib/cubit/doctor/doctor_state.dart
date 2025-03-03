part of 'doctor_cubit.dart';

sealed class DoctorListState {}

final class DoctorListInitial extends DoctorListState {}
class DoctorListLoading extends DoctorListState {}

class DoctorListSuccess extends DoctorListState {
   final List<Doctor> doctors;
  DoctorListSuccess(this.doctors);  
}

class DoctorListError extends DoctorListState {
  final String error;
  DoctorListError(this.error);
}