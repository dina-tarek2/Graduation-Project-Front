part of 'records_list_cubit.dart';

@immutable
abstract class RecordsListState {}

class RecordsListInitial extends RecordsListState {}

class RecordsListLoading extends RecordsListState {}

class RecordsListSuccess extends RecordsListState {
  final List<RecordsListModel> records;

  RecordsListSuccess(this.records);
}

class RecordLoaded extends RecordsListState {
  final RecordsListModel record;
  RecordLoaded(this.record);
}

class RecordsListFailure extends RecordsListState {
  final String error;
  RecordsListFailure(this.error);
}
class ExtendedDeadlineSuccess extends RecordsListState {}


