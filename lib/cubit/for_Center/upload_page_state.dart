part of 'upload_page_cubit.dart';

sealed class UploadDicomState {}

final class UploadDicomInitial extends UploadDicomState {}

class UploadDicomLoading extends UploadDicomState {
  final List<UploadingFile> uploads;

  UploadDicomLoading({required this.uploads});
}

class UploadingFile {
  final String fileName;
  final String fileSize;
  final double progress;

  UploadingFile(
      {required this.fileName, required this.fileSize, required this.progress});
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
