// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:graduation_project_frontend/api_services/end_points.dart';

class SignInModel {
  late final String token ;
  SignInModel({
    required this.token,
  });
 factory SignInModel.fromJson(Map<String,dynamic> jsonData){
   return SignInModel(
    token: jsonData[ApiKey.token],
   );
 }
}
