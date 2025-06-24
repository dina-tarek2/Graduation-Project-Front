class EndPoints {
  static String baseUrl1 = "https://graduation-project-mmih.vercel.app/api/";
  static String baseUrl = "https://graduation-project--xohomg.fly.dev/api/";
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
  static String GetRecordsByRadiologistId(String id) =>
      "Record/getRecordsByRadiologistId/$id";

  static String extendDeadline(String recordId) =>
      "Record/extendStudyDeadline/$recordId";
  static String analyzeImage(String id) =>
      "AIReports/analyzeImage/$id"; //67c5a83c4b4c95a43a780f78
  static String upload(String id, String? email, bool? flag) {
    String url = "upload_dicom?centerId=$id";

    if (email != null) {
      url += "&email=$email";
    }

    if (flag != null) {
      url += "&useOuerRadiologist=$flag";
    }

    return url;
  }

  static String showImages(id) =>
      "https://dicom-fastapi.fly.dev/show_images/$id";
  static String GetRecordsByCenterId(String id) =>
      "/Record/getRecordsByCenterId/$id";

  static String GetCommentsById(String id) =>
      "/comments/getAllCommentsByRecordId/$id";
  static String addCommentsById = "/comments/addcommmet";
  static String deleteCommentById(String id) => "/comments/deleteComment/$id";
  static String RedirectToDoctorFromRadintal(String id) =>
      "/Record/redirectToOurRadiologist/$id";
  static String getReviewedReport(String reportId) =>
      "AIReports/getOneAIReport/$reportId";
  //Admin - in center
  static String getApprovedCenters = "admin/getApprovedRadiologyCenters";
  static String addCenterByAdmin = "admin/addRadiologyCenter";
  static String getNotApprovedCenters = "admin/getNotApprovedRadiologyCenters";
  static String removeCenter(centerId) =>
      "admin/removeRadiologyCenter/$centerId";
  static String getCenterInfoByAdmin(centerId) =>
      "admin/getRadiologyCenter/$centerId";
  static String approveCenterAdmin(centerId) =>
      "admin/approveRadiologyCenter/$centerId";
  //admin -indoctor
  static String getDoctorsByAdmin = "admin/getRadiologists";
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
  static String baseUrl1 = "https://graduation-project-mmih.vercel.app/api/";
  static String baseUrl = "https://graduation-project--xohomg.fly.dev/api/";

  static String getAllReports = "AIReports/getAllAIReports";
  static String getReport(id) => "AIReports/getOneAIReport/$id";
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
