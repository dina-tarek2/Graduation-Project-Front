part of 'dicom_cubit.dart';

@immutable
sealed class DicomState {}
final class DicomInitial extends DicomState {}
class DicomLoading extends DicomState {}
class DicomLoaded extends DicomState {
  final List<String> images;
   final List<ImageProvider> cachedImages; 
  final int currentIndex;
   final double brightness;
  DicomLoaded(this.images,this.cachedImages, this.currentIndex,this.brightness);
}
class DicomUpdated extends DicomState {  
  final double brightness;
  DicomUpdated(this.brightness);
   }

class DicomError extends DicomState {
  final String message;
  DicomError(this.message);
}