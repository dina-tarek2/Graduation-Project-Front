// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:graduation_project_frontend/api_services/end_points.dart';

class OtpModel {
  final String message;
  final String token;
  final Map<String, dynamic> data;

  OtpModel({required this.message, required this.token, required this.data});

  factory OtpModel.fromJson(Map<String, dynamic> jsonData, String role) {
    return OtpModel(
      message: jsonData[ApiKey.message],
      token: jsonData[ApiKey.token],
      data: role == "Technician" ? jsonData[ApiKey.radiologyCenter] : jsonData[ApiKey.Radiologist],
    );
  }
}
