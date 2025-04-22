part of 'doctors_cubit.dart';

sealed class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object> get props => [];
}

final class DoctorsInitial extends DoctorsState {}

final class DoctorsLoading extends DoctorsState {}

final class DoctorsSuccess extends DoctorsState {
   final List<Datum> doctors;

  DoctorsSuccess({required this.doctors});
}

final class DoctorsFailure extends DoctorsState {
  final String error;

  DoctorsFailure({required this.error});
}