import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
   CustomButton({super.key, this.onTap, required this.text, this.width});

  VoidCallback? onTap;
  String text; 
  double? width; 

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                //width: double.infinity,//to take width of full screen
                width: width,
                height: 48,
                child: Center(
                  // child: Text(text),
                         child: Text(
                              text,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                  ),
              ),
    );
  }
}