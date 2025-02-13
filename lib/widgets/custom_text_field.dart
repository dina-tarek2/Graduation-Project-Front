import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';

class CustomFormTextField extends StatelessWidget {
  //give it default value false , عشان متروحش لكل واحد و تديله قيمة و انا دكدا كدا مش عاوزة تتعمل غير ف الباسورد بس و دا بسبب اني لازم تبتصي قيمة تحت و تكون مش ب null
  CustomFormTextField({
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.icon,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.width,
    this.height,
  });

  TextEditingController? controller;
  String? hintText;
  IconData? icon;
  bool? obscureText;
  final Widget? suffixIcon;
  final VoidCallback? suffixIconOnPressed;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return
        //to take input from user
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          obscureText: obscureText!, //to hide password
          //used inside form
          validator: (data) {
            if (data!.isEmpty) return 'field is required';
          },
          controller: controller,
          minLines: obscureText == true ? 1 : minLines,
          maxLines: obscureText == true ? 1 : (maxLines ?? 1),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            //general , donot touch it , only appear on screen
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            //more specific , when you touch textfield
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: sky,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: suffixIconOnPressed, // ✅ استخدم الدالة هنا
                    icon: Icon(BlocProvider.of<LoginCubit>(context).suffixIcon,
                        color: Colors.blue),
                  )
                : null,
            iconColor: Colors.white, // Ensures icon stays white
            prefixIconConstraints:
                BoxConstraints(minWidth: 40, minHeight: 40), // Adjust padding
            filled: false, // Prevents grey background
          ),
        ),
      ),
    );

    // );
  }
}
