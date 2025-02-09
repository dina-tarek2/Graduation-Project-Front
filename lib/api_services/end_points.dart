class EndPoints {
  static String baseUrl = "https://graduation-project-mmih.vercel.app/api/";
  //for radiologyCenter
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
