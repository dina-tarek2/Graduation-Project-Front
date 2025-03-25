
class EndPoints {
  static String baseUrl = "https://graduation-project-mmih.vercel.app/api/";
   static String DicomBaseUrl="https://dicom-file-git-main-ahmed0rasheds-projects.vercel.app/";
  //for radiologyCenter
  static String SignIn ="RadiologistAuth/login";
  static String signInWithGoogle ="/patientAuth/signWithGoogle";
  static String DicomList ="get_all_dicom_files";
  static String SentEmail ="auth/SendEmail";
  // static String getImages ="show_images/$dicomId";
  //register
  static String SignUpCenter = "auth/registerRadiologyCenter";
  static String SignUpDoctor = "RadiologistAuth/registerRadiologist";
  //otp
  static String VerifyOtpCenter = "auth/verifyOtp";
  static String VerifyOtpDoctor = "RadiologistAuth/verifyOtp";
  //doctor
  static String GetRecordsByRadiologistId =
      "Record/getRecordsByRadiologistId/67bcebe6567f01f3d25677f5";
  static String analyzeImage(String id) => "AIReports/analyzeImage/$id";//67c5a83c4b4c95a43a780f78    
  //Doctor List 
   static String getCenterId(id){
    return'/relations/radiologists/$id';
  }
}
class EndPointsForReport{
  static String baseUrl="https://graduation-project-mmih.vercel.app/api/";
  static String getAllReports ="AIReports/getAllAIReports"; 
  static String getPatientDetials(id){
    return "Record/getRecordById/$id";
  }
}

class ApiKey {
  static String message = "message";
  static String email = "email";
  static String name = "name";
  static String massage = "massage";
  static String password = "password";
  static String phone = "phone";

  static String token = "token";
  static String id = "id";
  static String role = "role";

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
