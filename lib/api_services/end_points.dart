import 'package:flutter/rendering.dart';

class EndPoints {
  static String baseUrl = "https://graduation-project-mmih.vercel.app/api/";
   static String DicomBaseUrl="https://dicom-file-git-main-ahmed0rasheds-projects.vercel.app/";
  //for radiologyCenter
  static String SignIn ="auth/loginRadiologyCenter";
  static String signInWithGoogle ="/patientAuth/signWithGoogle";
  static String DicomList ="get_all_dicom_files";
  // static String getImages ="show_images/$dicomId";
  static String SignIn = "auth/loginRadiologyCenter";
  //register
  static String SignUpCenter = "auth/registerRadiologyCenter";
  static String SignUpDoctor = "RadiologistAuth/registerRadiologist";
  //otp
  static String VerifyOtpCenter = "auth/verifyOtp";
  static String VerifyOtpDoctor = "RadiologistAuth/verifyOtp";

  static String signInWithGoogle = "/patientAuth/signWithGoogle";
}

class ApiKey {
  static String message = "message";
  static String email = "email";
  static String password = "password";

  static String token = "token";
  static String id = "id";
  static String googleToken = "googleToken";

  //register
  static String firstName = "firstName";
  static String lastName = "lastName";
  static String specialization = "specialization";

  static String contactNumber = "contactNumber";

  static String centerName = "centerName";
  static String address = "address";

  //otp
  static String otp = "otp";

  static String radiologyCenter = "radiologyCenter";
  static String Radiologist = "Radiologist";
}
