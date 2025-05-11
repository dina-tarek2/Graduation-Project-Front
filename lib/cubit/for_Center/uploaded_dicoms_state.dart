part of 'uploaded_dicoms_cubit.dart';

@immutable
sealed class UploadedDicomsState {}

final class UploadedDicomsInitial extends UploadedDicomsState {}

final class UploadedDicomsLoading extends UploadedDicomsState {}

final class UploadedDicomsSuccess extends UploadedDicomsState {
  final List<RecordModel> dicoms;

  UploadedDicomsSuccess(this.dicoms);
}

final class UploadedDicomsFailure extends UploadedDicomsState {
  final String error;

  UploadedDicomsFailure(this.error);
}
