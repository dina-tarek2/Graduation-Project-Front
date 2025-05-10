import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/cubit/DashboardCenter/medical_dashboard_cubit.dart';
import 'package:graduation_project_frontend/screens/Doctor/report_page.dart';
import 'package:graduation_project_frontend/screens/aboutUs.dart';
import 'package:graduation_project_frontend/screens/splashScreen.dart';
import 'package:graduation_project_frontend/screens/welcomePage.dart';
import 'package:graduation_project_frontend/widgets/DoctorReportsChart.dart';

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
import 'package:graduation_project_frontend/widgets/doctorAvgTime.dart';

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
                RecordsListCubit(DioConsumer(dio: Dio()))..fetchRecords()),
                  BlocProvider(create: (context) => CenterCubit()),
          BlocProvider(create: (context) => UserCubit()), //-
    BlocProvider(
      create: (context) => DashboardCubit(repository: centerDashboardRepository( DioConsumer(dio: Dio()),context.read<CenterCubit>().state)
      )),
        BlocProvider(
          create: (context) => ReportPageCubit(DioConsumer(dio: Dio())),
          //..fetchReport(),
        ),

        
        BlocProvider<LoginCubit>(
          create: (context) =>
              LoginCubit(UserRepository(api: DioConsumer(dio: Dio()),centerCubit: context.read<CenterCubit>(),userCubit:context.read<UserCubit>() )),
        ),
      
        BlocProvider(
            create: (context) => DicomCubit(DioConsumer(dio: Dio()))), //-
        BlocProvider(
            create: (context) => MedicalReportsCubit(
                repository: MedicalRepository(api: DioConsumer(dio: Dio()))
            )
        ),
               BlocProvider(
          create: (context) => ContactCubit(DioConsumer(dio: Dio())),
        ),   
         BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
        //  BlocProvider(create: (context) => ContactCubit(DioConsumer(dio: Dio()))),
    BlocProvider(
      create: (context) => ForgetPasswordCubit(DioConsumer(dio: Dio())),
      
    ),

    BlocProvider(
            create: (context) =>
                DoctorProfileCubit(DioConsumer(dio: Dio()))),
                  BlocProvider(
            create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
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
        DoctorDashboard.id:(context) => DoctorDashboard(),
        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        ForgetPassword.id:(context) => ForgetPassword(),
        // ManageDoctorsPage.id :(context) => ManageDoctorsPage(),
        OtpResetpassword.id :(context) => OtpResetpassword(),
        ResetPassword.id :(context) => ResetPassword(),
        DoctorReportsChart.id:(context) => DoctorReportsChart(doctors: context.read<DoctorCubit>().doctors,),
        ChatScreen.id :(context) => ChatScreen(userId: context.read<CenterCubit>().state,userType: context.read<UserCubit>().state,),
        // MainScaffold.id :(context) => MainScaffold(),

         //doctor
        // HomePage.id: (context) => HomePage(role: "Radiologist"),
        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        MedicalDashboardScreen.id: (context) =>
            MedicalDashboardScreen(),
        //doctor
        RecordsListPage.id: (context) => RecordsListPage(),
        MedicalReportPage.id: (context) => MedicalReportPage(),
        //
        DicomWebViewPage.id: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DicomWebViewPage(url: args['url']);
        },
        SplashScreen.id:(context)=>SplashScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        AboutUsPage.id:(context)=>AboutUsPage(),
        DoctorAvgTimeWidget.id :(context)=>DoctorAvgTimeWidget(avgMinutes: 20,)
      },
    );
  }
}

