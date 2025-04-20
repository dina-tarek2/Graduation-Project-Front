import 'dart:io';
import 'dart:typed_data';

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

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['dcm'],
    );

    if (result != null) {
      selectedFiles = result.paths.map((path) => File(path!)).toList();
      print(' ${selectedFiles.length} chosen');
      await uploadAllFilesIndividually();
    } else {
      // المستخدم لغى الاختيار
    }
  }

//List<File> files
//   Future<void> upload(List<File> files) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['dcm'],
//     );

//     File dicomFile = File(result!.files.single.path!);

//     if (!dicomFile.existsSync()) {
//       emit(UploadDicomFailure(error: "The selected file does not exist."));
//       return;
//     }

//     // Uint8List? fileBytes = result.files.single.bytes;
//     // String fileName = result.files.single.name;
//     // if (fileBytes == null) {
//     //   emit(UploadDicomFailure(error: "Failed to read file"));
//     //   return;
//     // }

//     // تجهيز بيانات الطلب بصيغة FormData
//     FormData formData = FormData.fromMap({
//       "file": await MultipartFile.fromFile(dicomFile.path,
//           filename: dicomFile.path.split('/').last),
//     });

//     // FormData formData = FormData.fromMap({
//     //   "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
//     // });

//    // ده هيجيب بس اسم الملف، من غير المسار
// final fileName = dicomFile.path.split(Platform.pathSeparator).last;
//     final fileSizeInBytes = await dicomFile.length();
//     final fileSizeInMB = (fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2);

//     emit(UploadDicomLoading(
//       progress: 0.0,
//       fileName: fileName,
//       fileSize: "$fileSizeInMB MB",
//     ));

//     try {
//       final response = await api.post(
//         EndPoints.upload,
//         isFromData: true,
//         data: formData,
//         cancelToken: _cancelToken,
//         onSendProgress: (int sent, int total) {
//           double progress = sent / total;
//           emit(UploadDicomLoading(
//             progress: progress,
//             fileName: fileName,
//             fileSize: "$fileSizeInMB MB",
//           )); // تحديث التقدم
//         },
//       );

//       final uploadModel = UploadModel.fromJson(response.data);

//       if (uploadModel.message == "DICOM file uploaded successfully") {
//         emit(UploadDicomSuccess());
//       } else {
//         emit(UploadDicomFailure(error: uploadModel.message!));
//       }
//     } catch (error) {
//       if (error is DioException) {
//         print("DioException Error: ${error.message}");
//         print("DioException Response: ${error.response?.data}");
//         print("DioException Status Code: ${error.response?.statusCode}");
//       } else {
//         print("Unknown Error: $error");
//       }
//       emit(UploadDicomFailure(error: "$error"));
//     }
//   }

  Future<void> uploadAllFilesIndividually() async {
    if (selectedFiles.isEmpty) {
      emit(UploadDicomFailure(error: " No files chosen."));
      return;
    }

    int successCount = 0;
    int failCount = 0;

    for (var dicomFile in selectedFiles) {
      if (!dicomFile.existsSync()) {
        failCount++;
        emit(UploadDicomFailure(error: "File ${dicomFile.path} doesnot exist."));
        continue;
      }

      final fileName = dicomFile.path.split(Platform.pathSeparator).last;
      final fileSizeInBytes = await dicomFile.length();
      final fileSizeInMB = (fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2);

      emit(UploadDicomLoading(
        progress: 0.0,
        fileName: fileName,
        fileSize: "$fileSizeInMB MB",
      ));

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          dicomFile.path,
          filename: fileName,
        ),
      });

      try {
        final response = await api.post(
          EndPoints.upload,
          isFromData: true,
          data: formData,
          cancelToken: _cancelToken,
          onSendProgress: (int sent, int total) {
            double progress = sent / total;
            emit(UploadDicomLoading(
              progress: progress,
              fileName: fileName,
              fileSize: "$fileSizeInMB MB",
            ));
          },
        );

        final uploadModel = UploadModel.fromJson(response.data);

        if (uploadModel.message == "DICOM file uploaded successfully") {
          successCount++;
          emit(UploadDicomSuccess());
           await showimages(uploadModel.publicId!);
          print("returned heree again");
        } else {
          failCount++;
          emit(UploadDicomFailure(
              error: uploadModel.message ?? "Unknown errorr"));
        }
      } catch (error) {
        failCount++;
        emit(UploadDicomFailure(error: "$error"));
      }
    }

    
    selectedFiles.clear(); 

    emit(UploadDicomSummary(
      successCount: successCount,
      failCount: failCount,
    ));
  }



  Future<void> showimages(String publicId) async {
    try {
      final response = await api.get(EndPoints.showImages(publicId));

      if (response.statusCode == 200) {
        print("show images done successfully");
      }
    }  catch (error) {
    
      if (error is DioException) {
        print("DioException Error: ${error.message}");
        print("DioException Response: ${error.response?.data}");
        print("DioException Status Code: ${error.response?.statusCode}");
      } else {
        print("Unknown Error: $error");
      }
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
