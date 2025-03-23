import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:webview_windows/webview_windows.dart';

// Cubits
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_cubit.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_cubit.dart';
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
import 'package:graduation_project_frontend/screens/forget_password.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom.dart';
import 'package:graduation_project_frontend/screens/medical_report_list.dart';
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
                RecordsListCubit(DioConsumer(dio: Dio()))..fetchRecords()), //-
        BlocProvider(
          //-
          create: (context) => LoginCubit(UserRepository(
            //-
            api: DioConsumer(dio: Dio()), //-
            centerCubit: context.read<CenterCubit>(), //-
          )), //-
        ), //-
        BlocProvider(
            create: (context) => DicomCubit(DioConsumer(dio: Dio()))), //-
        BlocProvider(
            //-
            create: (context) => ContactCubit(DioConsumer(dio: Dio()))), //-
        BlocProvider(
          //-
          create: (context) => MedicalReportsCubit(
            //-
            repository: MedicalRepository(api: DioConsumer(dio: Dio())), //-
          ), //-
        ), //-
        BlocProvider(
            create: (context) => DoctorCubit(DioConsumer(dio: Dio()))), //-
        BlocProvider(
            //-
            create: (context) =>
                DoctorProfileCubit(DioConsumer(dio: Dio()))), //-
      ], //-
      child: const MyApp(), //-
    ), //-
  ); //-
  // ... rest of the code//+
} // {"conversationId":"00a1ede0-0309-41ca-b949-aa6fb68964c1","source":"instruct"}

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
        HomePage.id: (context) => HomePage(role: "Radiologist"),
        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        ForgetPassword.id: (context) => ForgetPassword(),
        CenterDashboard.id: (context) =>
            CenterDashboard(role: "RadiologyCenter"),
        RecordsListPage.id: (context) => RecordsListPage(),
        DicomWebViewPage.id: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DicomWebViewPage(url: args['url']);
        },
      },
    );
  }
}
