import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  //give it default value false , عشان متروحش لكل واحد و تديله قيمة و انا دكدا كدا مش عاوزة تتعمل غير ف الباسورد بس و دا بسبب اني لازم تبتصي قيمة تحت و تكون مش ب null
  CustomFormTextField({this.hintText, this.onChanged, this.obscureText = false, this.icon});

  Function(String)?
      onChanged; //cannot use voidcallback func here bec voidcallback func doesnot take any arguments and we need our func to take arguments
  String? hintText;
  IconData? icon;
  bool? obscureText;//nullable
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
      onChanged: onChanged, //باصيه not to call it
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
          prefixIcon: icon != null ? Icon(icon) : null,
           iconColor: Colors.white, // Ensures icon stays white
    prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40), // Adjust padding
    filled: false, // Prevents grey background
         ),       
      );
    // );
  }
}
