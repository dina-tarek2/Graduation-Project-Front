import 'package:flutter/rendering.dart';

class EndPoints {
  static String baseUrl = "https://graduation-project-mmih.vercel.app/api/";
   static String DicomBaseUrl="https://dicom-file-git-main-ahmed0rasheds-projects.vercel.app/";
  //for radiologyCenter
  static String SignIn ="auth/loginRadiologyCenter";
  static String signInWithGoogle ="/patientAuth/signWithGoogle";
  static String DicomList ="get_all_dicom_files";
  // static String getImages ="show_images/$dicomId";
}

class Class {
}
class ApiKey{
  static String massage ="message";
  static String email ="email";
  static String password ="password";
  static String token ="token";
  static String id ="id";
  static String googleToken ="googleToken";
}