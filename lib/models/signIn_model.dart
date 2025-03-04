// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import '../api_services/end_points.dart';

class SignInModel {
  late final String token ;
  late final String? role ;
  late final String? id ;

  
  SignInModel({
    required this.token,
    required this.role,
     this.id,
  });
 factory SignInModel.fromJson(Map<String,dynamic> jsonData){
   return SignInModel(
    token: jsonData[ApiKey.token] ?? '',
    role: jsonData[ApiKey.role],
    id: jsonData[ApiKey.id],
   );
 }
}
