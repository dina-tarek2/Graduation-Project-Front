part of 'upload_page_cubit.dart';

// @immutable
sealed class UploadDicomState {}

final class UploadDicomInitial extends UploadDicomState {}

class UploadDicomLoading extends UploadDicomState {
  final double progress;
  final String fileName;
  final String fileSize;

  UploadDicomLoading({
    required this.progress,
    required this.fileName,
    required this.fileSize,
  });
}

final class UploadDicomSuccess extends UploadDicomState {}

class UploadDicomSummary extends UploadDicomState {
  final int successCount;
  final int failCount;

  UploadDicomSummary({
    required this.successCount,
    required this.failCount,
  });
}

final class UploadDicomFailure extends UploadDicomState {
 final String error;

  UploadDicomFailure({required this.error});
}
