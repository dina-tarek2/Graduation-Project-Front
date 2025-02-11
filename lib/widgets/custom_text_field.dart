import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';

class CustomFormTextField extends StatelessWidget {
  //give it default value false , عشان متروحش لكل واحد و تديله قيمة و انا دكدا كدا مش عاوزة تتعمل غير ف الباسورد بس و دا بسبب اني لازم تبتصي قيمة تحت و تكون مش ب null
  CustomFormTextField({this.hintText,
   this.controller,this.obscureText = false, 
   this.icon,this.suffixIcon,
      this.suffixIconOnPressed,
});

  // Function(String)?
  //     onChanged; //cannot use voidcallback func here bec voidcallback func doesnot take any arguments and we need our func to take arguments
  TextEditingController ? controller;
  String? hintText;
  IconData? icon;
  bool? obscureText;//nullable
  final Widget? suffixIcon; 
  final VoidCallback? suffixIconOnPressed;
  @override
  Widget build(BuildContext context) {
    return
        //to take input from user
        TextFormField(
      obscureText: obscureText!, //to hide password
      //used inside form
      validator: (data) {
        //لو مبعتش حاجة , data هتكون فاضية , not null , it will be empty string
        if (data!.isEmpty) //not null , so ypu must تاكد عليه انها مش ب null
          return 'field is required';
      },
      // onChanged: onChanged, //باصيه not to call it
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          // color: Color(0x899CC9),
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey), // اللون الافتراضي
            // الكيرف هنا
            //   borderSide: BorderSide(
            //     color: Colors.yellow,
            //  ),
            ),
        //general , donot touch it , only appear on screen
        enabledBorder: OutlineInputBorder(
          // borderSide: BorderSide(
          //   color:Colors.grey,
          //   // radius: BorderRadius.circular(15.0),
          // ),
           borderRadius: BorderRadius.circular(15),
           borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        //more specific , when you touch textfield
            focusedBorder: OutlineInputBorder(
            // borderSide: BorderSide(
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue, width: 2),
           ),
          prefixIcon: icon != null ? Icon(icon,color:sky,) : null,
           suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixIconOnPressed, // ✅ استخدم الدالة هنا
                icon: Icon(BlocProvider.of<LoginCubit>(context).suffixIcon, color: Colors.blue),
              )
            : null,
           iconColor: Colors.white, // Ensures icon stays white
    prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40), // Adjust padding
    filled: false, // Prevents grey background
         ),       
      );
    // );
  }
}
