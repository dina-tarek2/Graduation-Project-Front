part of 'uploaded_dicoms_cubit.dart';


sealed class UploadedDicomsState {}

final class UploadedDicomsInitial extends UploadedDicomsState {}

final class UploadedDicomsLoading extends UploadedDicomsState {}


final class UploadedDicomsSuccess extends UploadedDicomsState {
  final List<RecordModel> dicoms;

  UploadedDicomsSuccess(this.dicoms);
}
final class UploadedDicomsFlagSuccess extends UploadedDicomsState {
  final String message;

  UploadedDicomsFlagSuccess(this.message);
}
final class UploadedDicomsFailure extends UploadedDicomsState {
  final String error;

  UploadedDicomsFailure(this.error);
}

//reassign
final class ReassignedSuccessfully extends UploadedDicomsState {}


final class ReassignFailure extends UploadedDicomsState {
  final String error;

  ReassignFailure(this.error);
}
final class CommentSuccessfully extends UploadedDicomsState {}


final class CommentFailure extends UploadedDicomsState {
  final String error;

  CommentFailure(this.error);
}