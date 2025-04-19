class EndPoints {
  static String baseUrl = "https://graduation-project-mmih.vercel.app/api/";
  static String DicomBaseUrl =
      "https://dicom-file-git-main-ahmed0rasheds-projects.vercel.app/";
  //for radiologyCenter
  static String SignIn = "RadiologistAuth/login";
  static String signInWithGoogle = "/patientAuth/signWithGoogle";
  static String DicomList = "get_all_dicom_files";
  static String SentEmail = "auth/SendEmail";
  // static String getImages ="show_images/$dicomId";
  //register
  static String SignUpCenter = "auth/registerRadiologyCenter";
  static String SignUpDoctor = "RadiologistAuth/registerRadiologist";
  //otp
  static String VerifyOtpCenter(otp, email, password, centerName, contactNumber,
          zipCode, street, city, state) =>
      "auth/verify-otp/$email/$otp/$password/$centerName/$contactNumber/$zipCode/$street/$city/$state";

  static String VerifyOtpDoctor = "RadiologistAuth/verifyOtp";
  //doctor
  static String GetRecordsByRadiologistId =
      "Record/getRecordsByRadiologistId/67fd9050433fe6d2e1d18f56";
  static String analyzeImage(String id) =>
      "AIReports/analyzeImage/$id"; //67c5a83c4b4c95a43a780f78
  //center
  static String upload = "upload_dicom?centerId=67fea9142e0c58da5a1b3619";
  static String GetRecordsByCenterId =
      "/Record/getRecordsByCenterId/67fea9142e0c58da5a1b3619";
  //Admin
  static String getApprovedCenters = "admin/getApprovedRadiologyCenters";
  static String addCenterByAdmin = "admin/addRadiologyCenter";
  static String getNotApprovedCenters = "admin/getNotApprovedRadiologyCenters";

  //Doctor List
  static String getCenterId(id) {
    return '/relations/radiologists/$id';
  }

  //forgetPassword
  static String ForgetPassword = 'auth/forgotPassword';
  static String CheckOtp = 'auth/checkOtp';
  static String ResetPassword = 'auth/resetPassword';
}

class EndPointsForReport {
  static String baseUrl = "https://graduation-project-mmih.vercel.app/api/";
  static String getAllReports = "AIReports/getAllAIReports";
  static String getPatientDetials(id) {
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
  static String id1 = "_id";
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
  static String newPassword = "newPassword";

  static String radiologyCenter = "radiologyCenter";
  static String Radiologist = "Radiologist";
}
