import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';
import 'package:graduation_project_frontend/models/Techancian/upload_model.dart';
import 'package:file_picker/file_picker.dart';

part 'upload_page_state.dart';

class UploadDicomCubit extends Cubit<UploadDicomState> {
  UploadDicomCubit(this.api) : super(UploadDicomInitial());

  final ApiConsumer api;
  CancelToken? _cancelToken;
  List<File> selectedFiles = [];
  final CancelToken cancelToken = CancelToken();
  final List<UploadingFile> currentUploads = [];

  Future<void> pickFiles(String centerid) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['dcm'],
    );

    if (result != null) {
      selectedFiles = result.paths.map((path) => File(path!)).toList();
      await uploadAllFilesConcurrently(centerid);
    } else {
      // المستخدم لغى الاختيار
    }
  }

  Future<void> uploadAllFilesConcurrently(String centerid) async {
    if (selectedFiles.isEmpty) {
      emit(UploadDicomFailure(error: "No files chosen."));
      return;
    }

    int successCount = 0;
    int failCount = 0;
    currentUploads.clear();

    List<Future<void>> uploadTasks = [];

    for (var dicomFile in selectedFiles) {
      uploadTasks.add(_uploadSingleFile(dicomFile, centerid).then((success) {
        if (success) {
          successCount++;
        } else {
          failCount++;
        }
      }));
    }

    await Future.wait(uploadTasks);
    selectedFiles.clear();

    emit(UploadDicomSummary(successCount: successCount, failCount: failCount));
  }

  Future<bool> _uploadSingleFile(File dicomFile, String centerid) async {
    if (!dicomFile.existsSync()) {
      emit(UploadDicomFailure(error: "File ${dicomFile.path} does not exist."));
      return false;
    }

    final fileName = dicomFile.path.split(Platform.pathSeparator).last;
    final fileSizeInBytes = await dicomFile.length();
    final fileSizeInMB = (fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2);

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        dicomFile.path,
        filename: fileName,
      ),
    });

    try {
      final response = await api.post(
        EndPoints.upload(centerid),
        isFromData: true,
        data: formData,
        cancelToken: _cancelToken,
        onSendProgress: (int sent, int total) {
          double progress = sent / total;

          final existingIndex =
              currentUploads.indexWhere((e) => e.fileName == fileName);
          final model = UploadingFile(
            fileName: fileName,
            fileSize: "$fileSizeInMB MB",
            progress: progress,
          );

          if (existingIndex != -1) {
            currentUploads[existingIndex] = model;
          } else {
            currentUploads.add(model);
          }

          emit(UploadDicomLoading(uploads: List.from(currentUploads)));
        },
      );

      final uploadModel = UploadModel.fromJson(response.data);

      if (uploadModel.message == "DICOM file uploaded successfully") {
        await showimages(uploadModel.publicId!);
        return true;
      } else {
        emit(UploadDicomFailure(error: uploadModel.message ?? "Unknown error"));
        return false;
      }
    } catch (error) {
      emit(UploadDicomFailure(error: "$error"));
      return false;
    }
  }

  Future<void> showimages(String publicId) async {
    try {
      final response = await api.get(EndPoints.showImages(publicId));

      if (response.statusCode == 200) {

      }
    } catch (error) {
      emit(UploadDicomFailure(error: "$error"));
    }
  }

  void cancelUpload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("Upload cancelled by user");
      emit(UploadDicomInitial());
    }
  }
}
