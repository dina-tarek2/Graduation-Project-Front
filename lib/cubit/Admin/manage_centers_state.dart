part of 'manage_centers_cubit.dart';

sealed class ManageCentersState extends Equatable {
  const ManageCentersState();

  @override
  List<Object> get props => [];
}

final class ManageCentersInitial extends ManageCentersState {}

final class ManageCentersLoading extends ManageCentersState {}

class ManageCentersSuccess extends ManageCentersState {
  final List<Datum> centers;

  ManageCentersSuccess({required this.centers});
}

final class ManageCentersFailure extends ManageCentersState {
 final String error;

  ManageCentersFailure({required this.error});
}

//add center for admin
final class AddCenterSuccess extends ManageCentersState {}

final class AddCenterFailure extends ManageCentersState {
 final String error;

  AddCenterFailure({required this.error});
}
