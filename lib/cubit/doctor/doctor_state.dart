part of 'doctor_cubit.dart';

sealed class DoctorListState {}

final class DoctorListInitial extends DoctorListState {}
class DoctorListLoading extends DoctorListState {}

class DoctorListSuccess extends DoctorListState {
   final List<Doctor> doctors;
  DoctorListSuccess(this.doctors);  
}
class DoctorAddedSuccess extends DoctorListState {
   final String message;
  DoctorAddedSuccess(this.message);  
}

class DoctorDeletedSuccess extends DoctorListState {
   final String message;
  DoctorDeletedSuccess(this.message);  
}

class DoctorListError extends DoctorListState {
  final String error;
  DoctorListError(this.error);
}