part of 'report_page_cubit.dart';

@immutable
sealed class ReportPageState {}

final class ReportPageInitial extends ReportPageState {}

final class ReportPageLoading extends ReportPageState {}

final class ReportPageSuccess extends ReportPageState {
  final ReportModel report;//contains contents or data of report

  ReportPageSuccess({required this.report});
}

final class ReportPageFailure extends ReportPageState {
  final String errmessage;

  ReportPageFailure({required this.errmessage});
}
final class ReportUpdateSuccess extends ReportPageState{
  final String message;
  ReportUpdateSuccess({this.message = "Report updated successfully"});
}
