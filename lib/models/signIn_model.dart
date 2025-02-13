// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../api_services/end_points.dart';

class SignInModel {
  late final String token ;
  late final String? massage ;
  
  SignInModel({
    required this.token,
    this.massage,
  });
 factory SignInModel.fromJson(Map<String,dynamic> jsonData){
   return SignInModel(
    token: jsonData[ApiKey.token],
    massage: jsonData[ApiKey.massage],
   );
 }
}
