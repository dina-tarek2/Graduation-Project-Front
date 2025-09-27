import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radintel/cubit/For_Doctor/report_page_cubit.dart';
import 'package:radintel/cubit/DashboardCenter/medical_dashboard_cubit.dart';
import 'package:radintel/cubit/Admin/doctors_cubit.dart';
import 'package:radintel/cubit/Admin/not_approved_centers_cubit.dart';
import 'package:radintel/cubit/Admin/manage_centers_cubit.dart';
import 'package:radintel/cubit/Notification/notification_cubit.dart';
import 'package:radintel/cubit/for_Center/center_profile_cubit.dart';
import 'package:radintel/cubit/for_Center/upload_page_cubit.dart';
import 'package:radintel/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:radintel/screens/Admin/add_center_page.dart';
import 'package:radintel/screens/Admin/manage_centers_page.dart';
import 'package:radintel/screens/Admin/manage_doctorsA_page.dart';
import 'package:radintel/screens/Admin/requests_page.dart';
import 'package:radintel/screens/Center/dicoms_list_page.dart';
import 'package:radintel/screens/Center/upload_page.dart';
import 'package:radintel/screens/Doctor/new_dicom_page.dart';
import 'package:radintel/screens/Doctor/report_page.dart';
import 'package:radintel/screens/aboutUs.dart';
import 'package:radintel/screens/privacy_policy_page.dart';
import 'package:radintel/screens/splashScreen.dart';
import 'package:radintel/screens/terms_conditions_page.dart';
import 'package:radintel/screens/welcomePage.dart';
import 'package:radintel/widgets/DoctorReportsChart.dart';
// Cubits
import 'package:radintel/cubit/For_Doctor/records_list_cubit.dart';
import 'package:radintel/cubit/ReportsCubit/medical_reports_cubit.dart';
import 'package:radintel/cubit/doctor/doctor_cubit.dart';
import 'package:radintel/cubit/forgetPassword/forget_passeord_cubit.dart';
import 'package:radintel/cubit/doctor/doctor_profile_cubit.dart';
import 'package:radintel/cubit/contact_cubit.dart';
import 'package:radintel/cubit/dicom_cubit.dart';
import 'package:radintel/cubit/login_cubit.dart';
import 'package:radintel/cubit/register_cubit.dart';
// Repositories
import 'package:radintel/api_services/dio_consumer.dart';
import 'package:radintel/repositories/medical_repository.dart';
import 'package:radintel/repositories/user_repository.dart';
// Screens
import 'package:radintel/screens/Center_dashboard.dart';
import 'package:radintel/screens/Doctor/records_list_page.dart';
import 'package:radintel/screens/chatScreen.dart';
import 'package:radintel/screens/forget_password.dart';
import 'package:radintel/screens/doctor_home_page.dart';
import 'package:radintel/screens/contact_us_page.dart';
import 'package:radintel/screens/dicom.dart';
import 'package:radintel/screens/medical_report_list.dart';
import 'package:radintel/screens/otp_resetPassword.dart';
import 'package:radintel/screens/resetPassword.dart';
import 'package:radintel/screens/signin_page.dart';
import 'package:radintel/screens/signup_page.dart';
import 'package:radintel/screens/viewer.dart';
import 'package:radintel/widgets/doctorAvgTime.dart';
import 'package:radintel/cubit/HomeDoc/doctor_home_cubit.dart';

import 'cubit/setting_cubit.dart';
import 'screens/SettingPage.dart';

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
            create: (context) => DashboardCubit(
                repository: centerDashboardRepository(DioConsumer(dio: Dio()),
                    context.read<CenterCubit>().state))),

        BlocProvider(
          create: (context) => RecordsListCubit(DioConsumer(dio: Dio())),
        ),

        BlocProvider(
          create: (context) => ReportPageCubit(DioConsumer(dio: Dio())),
          //..fetchReport(),
        ),

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
//         BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
        //  BlocProvider(create: (context) => ContactCubit(DioConsumer(dio: Dio()))),
        BlocProvider(
          create: (context) => SettingCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => ForgetPasswordCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => UploadedDicomsCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
            create: (context) =>
                UploadDicomCubit(DioConsumer(dio: Dio(), isdicom: true))),
        BlocProvider(
            create: (context) => DoctorProfileCubit(DioConsumer(dio: Dio()))),
        BlocProvider(
            create: (context) => CenterProfileCubit(DioConsumer(dio: Dio()))),
        BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
        BlocProvider(
            create: (context) => NotificationCubit(DioConsumer(dio: Dio()))),
        BlocProvider(
            create: (context) => DoctorHomeCubit(DioConsumer(dio: Dio()))),
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
      initialRoute: SplashScreen.id,
      routes: {
        SigninPage.id: (context) => SigninPage(),
        SignupPage.id: (context) => SignupPage(),
        DicomListPage.id: (context) => DicomListPage(),
        NewDicomPage.id: (context) => NewDicomPage(),
        DoctorDashboard.id: (context) => DoctorDashboard(),

        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        ForgetPassword.id: (context) => ForgetPassword(),
        // ManageDoctorsPage.id :(context) => ManageDoctorsPage(),

        OtpResetpassword.id: (context) => OtpResetpassword(),
        ResetPassword.id: (context) => ResetPassword(),
        DoctorReportsChart.id: (context) => DoctorReportsChart(
              doctors: context.read<DoctorCubit>().doctors,
            ),
        ChatScreen.id: (context) => ChatScreen(
              userId: context.read<CenterCubit>().state,
              userType: context.read<UserCubit>().state,
            ),
        SettingsPage.id: (context) => SettingsPage(
            role: context.read<UserCubit>().state,
            centerId: context.read<CenterCubit>().state),
        // MainScaffold.id :(context) => MainScaffold(),

        //doctor
        // HomePage.id: (context) => HomePage(role: "Radiologist"),
//         ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        MedicalDashboardScreen.id: (context) => MedicalDashboardScreen(),
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

        RequestsPage.id: (context) => RequestsPage(),
        // ViewCenterProfilePage.id: (context) => ViewCenterProfilePage(centerId: "",),//???????
        ManageDoctorsaPage.id: (context) => ManageDoctorsaPage(),

        //
        DicomWebViewPage.id: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DicomWebViewPage(
              url: args['url'],
              reportId: args['reportId'],
              recordId: args['recordId']);
        },
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        AboutUsPage.id: (context) => AboutUsPage(),
        DoctorAvgTimeWidget.id: (context) => DoctorAvgTimeWidget(
              avgMinutes: 20,
            ),
        PrivacyPolicyPage.id: (context) => const PrivacyPolicyPage(),
        TermsConditionsPage.id: (context) => const TermsConditionsPage(),
      },
    );
  }
}
