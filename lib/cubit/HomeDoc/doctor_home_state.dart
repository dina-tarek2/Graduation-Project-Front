part of 'doctor_home_cubit.dart';

sealed class DoctorHomeState extends Equatable {
  const DoctorHomeState();

  @override
  List<Object> get props => [];
}

final class DoctorHomeInitial extends DoctorHomeState {}
final class DoctorHomeLoaded extends DoctorHomeState {
  final int avgTime;
  final Map<String, int> stats;
  final int recordCount;
 final List<CenterRecord> centerRecord;
  final Map<String,dynamic> weeklyStatusCounts;

    DoctorHomeLoaded( {required this.avgTime,
     required this.stats,
     required this.recordCount ,
     required this.centerRecord,
     required this.weeklyStatusCounts,
});
}
final class DoctorHomeLoading extends DoctorHomeState {}
final class DoctorHomeError extends DoctorHomeState {
 final String message;

  DoctorHomeError({required this.message});

}
