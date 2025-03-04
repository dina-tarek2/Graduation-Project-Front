part of 'records_list_cubit.dart';

@immutable
sealed class RecordsListState {}

final class RecordsListInitial extends RecordsListState {}

final class RecordsListLoading extends RecordsListState {}

final class RecordsListSuccess extends RecordsListState {
  final List<RecordsListModel> records;

   RecordsListSuccess(this.records);
}

class RecordsListFailure extends RecordsListState {
  final String error;
  RecordsListFailure(this.error);
}
