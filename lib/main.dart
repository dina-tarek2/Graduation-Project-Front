import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/cubit/Admin/doctors_cubit.dart';
import 'package:graduation_project_frontend/cubit/Admin/not_approved_centers_cubit.dart';
import 'package:graduation_project_frontend/cubit/Admin/manage_centers_cubit.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';

import 'package:graduation_project_frontend/cubit/for_Center/upload_page_cubit.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:graduation_project_frontend/screens/Admin/add_center_page.dart';
import 'package:graduation_project_frontend/screens/Admin/center_info_page.dart';
import 'package:graduation_project_frontend/screens/Admin/manage_centers_page.dart';
import 'package:graduation_project_frontend/screens/Admin/manage_doctorsA_page.dart';
import 'package:graduation_project_frontend/screens/Admin/requests_page.dart';
import 'package:graduation_project_frontend/screens/Center/center_profile.dart';
import 'package:graduation_project_frontend/screens/Center/dicoms_list_page.dart';
import 'package:graduation_project_frontend/screens/Center/upload_page.dart';

import 'package:graduation_project_frontend/screens/Doctor/report_page.dart';
import 'package:webview_windows/webview_windows.dart';

// Cubits
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_cubit.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_cubit.dart';
import 'package:graduation_project_frontend/cubit/forgetPassword/forget_passeord_cubit.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/contact_cubit.dart';
import 'package:graduation_project_frontend/cubit/dicom_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';

// Repositories
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/repositories/medical_repository.dart';
import 'package:graduation_project_frontend/repositories/user_repository.dart';

// Screens
import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
import 'package:graduation_project_frontend/screens/chatScreen.dart';
import 'package:graduation_project_frontend/screens/forget_password.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom.dart';
import 'package:graduation_project_frontend/screens/medical_report_list.dart';
import 'package:graduation_project_frontend/screens/otp_resetPassword.dart';
import 'package:graduation_project_frontend/screens/resetPassword.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';

import 'package:graduation_project_frontend/screens/viewer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //-

  runApp(
    //-
    MultiBlocProvider(
      //-
      providers: [
        //-
        BlocProvider(
            //-
            create: (context) => RegisterCubit(DioConsumer(dio: Dio()))), //-
        BlocProvider(create: (context) => CenterCubit()), //-
        BlocProvider(
            //-
            create: (context) => //-
                RecordsListCubit(DioConsumer(dio: Dio()))), //-

        BlocProvider(
          create: (context) => ReportPageCubit(DioConsumer(dio: Dio())),
          //..fetchReport(),
        ),

        BlocProvider(create: (context) => CenterCubit()),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(UserRepository(
              api: DioConsumer(dio: Dio()),
              centerCubit: context.read<CenterCubit>(),
              userCubit: context.read<UserCubit>())),
        ),

        //admin
        BlocProvider(
          create: (context) => ManageCentersCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => NotApprovedCentersCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => DoctorsCubit(DioConsumer(dio: Dio())),
        ),
        //

        BlocProvider(
            create: (context) => DicomCubit(DioConsumer(dio: Dio()))), //-
        BlocProvider(
            create: (context) => MedicalReportsCubit(
                repository: MedicalRepository(api: DioConsumer(dio: Dio())))),
        BlocProvider(
          create: (context) => ContactCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
        //  BlocProvider(create: (context) => ContactCubit(DioConsumer(dio: Dio()))),

        BlocProvider(
          create: (context) => ForgetPasswordCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => UploadedDicomsCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
            //-
            create: (context) =>
                UploadDicomCubit(DioConsumer(dio: Dio(), isdicom: true))),
        BlocProvider(
            create: (context) => DoctorProfileCubit(DioConsumer(dio: Dio()))),
        BlocProvider(
            create: (context) => CenterProfileCubit(DioConsumer(dio: Dio()))),
        BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
        BlocProvider(
            create: (context) => NotificationCubit(DioConsumer(dio: Dio()))),
      ],
      child: MyApp(), // Use MyApp instead of an empty Container
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SigninPage.id,
      routes: {
        SigninPage.id: (context) => SigninPage(),
        SignupPage.id: (context) => SignupPage(),
        DicomListPage.id: (context) => DicomListPage(),
        DashboardContent.id: (context) => DashboardContent(),
        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        ForgetPassword.id: (context) => ForgetPassword(),
        // ManageDoctorsPage.id :(context) => ManageDoctorsPage(),
        OtpResetpassword.id: (context) => OtpResetpassword(),
        ResetPassword.id: (context) => ResetPassword(),
        ChatScreen.id: (context) => ChatScreen(
              userId: context.read<CenterCubit>().state,
              userType: context.read<UserCubit>().state,
            ),
        // MainScaffold.id :(context) => MainScaffold(),

        //doctor
        // HomePage.id: (context) => HomePage(role: "Radiologist"),
        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        CenterDashboard.id: (context) =>
            CenterDashboard(role: "RadiologyCenter"),
        //doctor
        RecordsListPage.id: (context) => RecordsListPage(),
        MedicalReportPage.id: (context) => MedicalReportPage(),
        //center
        UploadScreen.id: (context) => UploadScreen(),
        // UploadButtonScreen.id:(context) => UploadButtonScreen(),

        DicomsListPage.id: (context) => DicomsListPage(),
        // admin
        ManageCentersPage.id: (context) => ManageCentersPage(),
        AddCenterPage.id: (context) => AddCenterPage(),

        RequestsPage.id: (context)=> RequestsPage(),
        // ViewCenterProfilePage.id: (context) => ViewCenterProfilePage(centerId: "",),//???????
        ManageDoctorsaPage.id: (context) => ManageDoctorsaPage(),

        //
        DicomWebViewPage.id: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DicomWebViewPage(url: args['url'], reportId: args['reportId'],recordId: args['recordId']);
        },
      },
    );
  }
}
