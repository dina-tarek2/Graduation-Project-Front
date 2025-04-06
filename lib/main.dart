
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_cubit.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_cubit.dart';
import 'package:graduation_project_frontend/cubit/forgetPassword/forget_passeord_cubit.dart';
import 'package:graduation_project_frontend/repositories/medical_repository.dart';
import 'package:graduation_project_frontend/repositories/user_repository.dart';
import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
import 'package:graduation_project_frontend/screens/chatScreen.dart';
import 'package:graduation_project_frontend/screens/forget_password.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/cubit/contact_cubit.dart';
import 'package:graduation_project_frontend/cubit/dicom_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom.dart';
import 'package:graduation_project_frontend/screens/medical_report_list.dart';
import 'package:graduation_project_frontend/screens/otp_resetPassword.dart';
import 'package:graduation_project_frontend/screens/resetPassword.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();   

  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(DioConsumer(dio: Dio())),
        ),

          BlocProvider(
            create: (context) => CenterCubit(),
          ),

        BlocProvider(
          create: (context) =>
              RecordsListCubit(DioConsumer(dio: Dio()))..fetchRecords(),
        ),

          BlocProvider(create: (context) => CenterCubit()),
          BlocProvider(create: (context) => UserCubit()),
        BlocProvider<LoginCubit>(
          create: (context) =>
              LoginCubit(UserRepository(api: DioConsumer(dio: Dio()),centerCubit: context.read<CenterCubit>(),userCubit:context.read<UserCubit>() )),
        ),
        BlocProvider(
          create: (context) => DicomCubit(DioConsumer(dio: Dio())),
        ),
        //  BlocProvider(
        //   create: (context) => HomePage(),
        // ),
        BlocProvider(
          create: (context) => ContactCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
            create: (context) => MedicalReportsCubit(
                repository: MedicalRepository(api: DioConsumer(dio: Dio()))
            )
        ),
                
         BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
    BlocProvider(
      create: (context) => ForgetPasswordCubit(DioConsumer(dio: Dio())),
      
    ),
    
    ], 
      child: MyApp(), // Use MyApp instead of an empty Container
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SignupPage(),
      routes: {
        // 'LoginPage' : (context) => LoginPage(),
        SigninPage.id: (context) => SigninPage(),
        SignupPage.id: (context) => SignupPage(),
        DicomListPage.id: (context) => DicomListPage(),
        DashboardContent.id:(context) => DashboardContent(),
        ContactScreen.id: (context) => ContactScreen(role: "Radiologist"),
        MedicalReportsScreen.id: (context) => MedicalReportsScreen(),
        ForgetPassword.id:(context) => ForgetPassword(),
        // ManageDoctorsPage.id :(context) => ManageDoctorsPage(),
        CenterDashboard.id :(context) => CenterDashboard(role: "RadiologyCenter"),
        OtpResetpassword.id :(context) => OtpResetpassword(),
        ResetPassword.id :(context) => ResetPassword(),
        ChatScreen.id :(context) => ChatScreen(userId: context.read<CenterCubit>().state,userType: context.read<UserCubit>().state,),
        // MainScaffold.id :(context) => MainScaffold(),

         //doctor
        RecordsListPage.id: (context) => RecordsListPage(),
        // MedicalReportPage.id: (context) => MedicalReportPage(),
      },
      initialRoute: SignupPage.id,
    );
  }
}
// import 'package:flutter/material.dart';  

// void main() {  
//   runApp(MyApp());  
// }  

// class MyApp extends StatelessWidget {  
//   @override  
//   Widget build(BuildContext context) {  
//     return MaterialApp(  
//       title: 'My App',  
//       home: HomePage(),  
//     );  
//   }  
// }  
