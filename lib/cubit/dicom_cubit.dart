import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:meta/meta.dart';


part 'dicom_state.dart';

class DicomCubit extends Cubit<DicomState> {
  DicomCubit(this.api,) : super(DicomInitial());
 ApiConsumer api ;
 final Dio dio = Dio();
  final String baseUrl = "https://dicom-file-git-main-ahmed0rasheds-projects.vercel.app/";
   List<String> images = [];
   List<ImageProvider> cachedImages = []; 
  int currentIndex = 0;
   double brightness = 1.0;
  //  String get currentImage => images.isNotEmpty ? images[currentIndex] : '';
  // Future<void> fetchDicomFiles() async {
  //   emit(DicomLoading());
  //   try {
  //     final response = await dio.get(
  //         'https://dicom-file-git-main-ahmed0rasheds-projects.vercel.app/get_all_dicom_files');
  //     if (response.statusCode == 200) {
  //        List<String>  dicomResponse = List<String>.from(response.data);
  //       emit(DicomLoaded(dicomResponse));
  //     } else {
  //       emit(DicomError('Failed to load DICOM files'));
  //     }
  //   } catch (e) {
  //     emit(DicomError(e.toString()));
  //   }
  // }
  Future<void> fetchDicomImages(String dicomId) async {  
  try {  
    emit(DicomLoading());
    final response = await dio.get('$baseUrl/show_images/$dicomId',
     options: Options(
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, Authorization",
          "Content-Type": "application/json"
       },
       )
        );
        
    // print("Response Data: ${response.data}"); 

   if (response.data != null && response.data['image_links'] != null) {  
        images = List<String>.from(
          response.data['image_links'].map((image) => '$baseUrl/$image')
        );
               cachedImages = images.map((url) => NetworkImage(url)).toList();
      currentIndex = 0;
      emit(DicomLoaded(images,cachedImages,currentIndex,brightness));  
    } else {  
      emit(DicomError('No image links found in the response.'));  
    }  
  } catch (e) {  
    print("Error fetching images: $e");  
    emit(DicomError("Failed to fetch images: $e"));  
  }  
}
 void nextImage() {
    if (currentIndex < images.length - 1) {
      currentIndex++;
      emit(DicomLoaded(List.from(images),cachedImages, currentIndex,brightness));
    }
 }
    void previousImage() {
    if (currentIndex > 0) {
      currentIndex--;
      emit(DicomLoaded(List.from(images),cachedImages, currentIndex,brightness));
    }
  }
  void updateImageBySlider(int newIndex) {
  if (newIndex >= 0 && newIndex < images.length) {
    currentIndex = newIndex;
    emit(DicomLoaded(List.from(images),cachedImages, currentIndex,brightness));
  }
}
 void adjustBrightness(double value) {  
    brightness = value.clamp(0.0, 5.0);  
  emit(DicomLoaded(images, cachedImages, currentIndex, brightness));
 }

}

