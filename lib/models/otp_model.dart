import 'package:graduation_project_frontend/api_services/end_points.dart';

class OtpModel {
  final String message;
  final Map<String, dynamic> data;

  OtpModel({required this.message, required this.data});

  factory OtpModel.fromJson(Map<String, dynamic> jsonData, String role) {
    return OtpModel(
      message: jsonData[ApiKey.message],
      data: role == "Technician"
          ? jsonData[ApiKey.radiologyCenter]
          : jsonData[ApiKey.Radiologist],   
    );
  }
}
