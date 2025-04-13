// import 'package:dio/dio.dart';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// Future<void> fetchDicomInstances() async {
//   final dio = Dio();
//   try {
//     final response = await dio.get("http://localhost:8042/instances");
//     print(response.data); // List of DICOM instances
//   } catch (e) {
//     print("Error: $e");
//   }
// }
// Future<void> downloadDicomImage(String instanceId) async {
//   final dio = Dio();
//   try {
//     final response = await dio.get(
//       "http://localhost:8042/instances/$instanceId/file",
//       options: Options(responseType: ResponseType.bytes),
//     );

//     // Load DICOM file
//     final dicomFile = Dicom.fromBytes(response.data);
//     print("DICOM loaded: ${dicomFile.toString()}");
//   } catch (e) {
//     print("Error: $e");
//   }
// }
// Future<Image> fetchRenderedImage(String instanceId) async {
//   final dio = Dio();
//   final response = await dio.get(
//     "http://localhost:8042/instances/$instanceId/rendered",
//     options: Options(responseType: ResponseType.bytes),
//   );

//   // Convert response bytes to image
//   Uint8List imageBytes = response.data;
//   return Image.memory(imageBytes!);
// }
// Future<void> uploadDicomFile(String filePath) async {
//   final dio = Dio();
//   final file = await MultipartFile.fromFile(filePath);
//   final formData = FormData.fromMap({"file": file});

//   try {
//     final response = await dio.post(
//       "http://localhost:8042/instances",
//       data: formData,
//     );
//     print("Upload successful: ${response.data}");
//   } catch (e) {
//     print("Error uploading DICOM: $e");
//   }
// }
