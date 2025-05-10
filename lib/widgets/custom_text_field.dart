import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';

class CustomFormTextField extends StatelessWidget {
  //give it default value false , عشان متروحش لكل واحد و تديله قيمة و انا دكدا كدا مش عاوزة تتعمل غير ف الباسورد بس و دا بسبب اني لازم تبتصي قيمة تحت و تكون مش ب null
  CustomFormTextField({super.key, 
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.icon,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.prefixIcon,
    this.validator, 
    this.width,
    this.height,
    this.onSubmitted,
      this.decoration = const InputDecoration(),
  });

  TextEditingController? controller;
  String? hintText;
  IconData? icon;
  bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? suffixIconOnPressed;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
   Key? key;
 final FormFieldValidator<String>? validator;
final InputDecoration decoration;
  final double? width;
  final double? height;
    final ValueChanged<String>? onSubmitted;


  @override
  Widget build(BuildContext context) {
    return
        //to take input from user
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

      child: SizedBox(
        width: width,
        child: TextFormField(
          obscureText: obscureText!, //to hide password
          //used inside form
          validator: validator,
              onFieldSubmitted: onSubmitted,
          /*(data) {
            if (data!.isEmpty)
           return 'field is required';
          },*/
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
                      size:16,
                      color:Colors.indigo
                    )
                  : null,
              suffixIcon:suffixIcon ?? (suffixIconOnPressed != null
    ? IconButton(
        onPressed: suffixIconOnPressed,
        icon: Icon(Icons.visibility, color: Colors.indigo), 
      )
    : null),
             
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
