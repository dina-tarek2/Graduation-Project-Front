import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';   

void main() {  
  // runApp(MyApp()); 
   runApp(
    BlocProvider(
      create: (context) => RegisterCubit(DioConsumer(dio: Dio())),
      child: MyApp(),
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
        },
        initialRoute: SignupPage.id,
    );  
  }  
}  
 