// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:graduation_project_frontend/api_services/end_points.dart';

class SignUpModel {
  final String message ;

 SignUpModel({required this.message});

 factory SignUpModel.fromJson(Map<String,dynamic> jsonData){
   return SignUpModel(
    message: jsonData[ApiKey.message],
   );
 } 
}
