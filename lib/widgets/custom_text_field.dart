import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

class CustomFormTextField extends StatelessWidget {

  CustomFormTextField(
      {this.hintText, this.controller, this.obscureText = false, this.icon});

  TextEditingController? controller;
  String? hintText;
  IconData? icon;
  bool? obscureText; //nullable
  @override
  Widget build(BuildContext context) {
    return
        //to take input from user
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        obscureText: obscureText!, //to hide password
        //used inside form
        validator: (data) {
          if (data!.isEmpty) 
            return 'field is required';
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
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
                  color: Colors.blue,
                )
              : null,
          iconColor: Colors.white, // Ensures icon stays white
          prefixIconConstraints:
              BoxConstraints(minWidth: 40, minHeight: 40), // Adjust padding
          filled: false, // Prevents grey background
        ),
      ),
    );
    // );
  }
}
