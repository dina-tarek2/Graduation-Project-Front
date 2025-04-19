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
