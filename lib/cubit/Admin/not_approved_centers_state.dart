part of 'not_approved_centers_cubit.dart';

sealed class NotApprovedCentersState extends Equatable {
  const NotApprovedCentersState();

  @override
  List<Object> get props => [];
}

final class NotApprovedCentersInitial extends NotApprovedCentersState {}

final class NotApprovedCentersLoading extends NotApprovedCentersState {}

final class NotApprovedCentersSuccess extends NotApprovedCentersState {
  final List<Datum> centers;

  NotApprovedCentersSuccess({required this.centers});
}

final class NotApprovedCentersFailure extends NotApprovedCentersState {
  final String error;

  NotApprovedCentersFailure({required this.error});
}

//center info
final class centerInfoLoading extends NotApprovedCentersState {}


final class centerInfoSuccess extends NotApprovedCentersState {
  final Datum center;

  centerInfoSuccess({required this.center});

}

final class centerInfoFailure extends NotApprovedCentersState {
  final String error;

  centerInfoFailure({required this.error});

}

//approve center
final class adminApprovedCenterLoading extends NotApprovedCentersState {}

final class adminApprovedCenterSuccessfully extends NotApprovedCentersState {}


final class adminApprovedCenterFailure extends NotApprovedCentersState {
   final String error;

  adminApprovedCenterFailure({required this.error});
}



