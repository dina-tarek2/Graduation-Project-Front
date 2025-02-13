import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/cubit/contact_cubit.dart';
import 'package:graduation_project_frontend/cubit/dicom_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom_list_page.dart';
import 'package:graduation_project_frontend/screens/home_page.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';   

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => DicomCubit(DioConsumer(dio: Dio())),
        ),
        //  BlocProvider(
        //   create: (context) => HomePage(),
        // ),
         BlocProvider(  
      create: (context) => ContactCubit(DioConsumer(dio: Dio())),  )
      ],
      child: MyApp(),  // Use MyApp instead of an empty Container

    ),
  );
}


class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return
     MaterialApp(  
      debugShowCheckedModeBanner: false,  
      // home: SignupPage(),       
        routes: {
          // 'LoginPage' : (context) => LoginPage(),
          SigninPage.id: (context) => SigninPage(),

          SignupPage.id: (context) => SignupPage(), 
          DicomListPage.id:(context) => DicomListPage(),
          HomePage.id:(context) => HomePage(),
           ContactScreen.id: (context) => ContactScreen(), 

        },
        initialRoute: SignupPage.id,
    );  
  }  
}