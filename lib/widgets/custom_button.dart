import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

class CustomButton extends StatelessWidget {
   CustomButton({this.onTap, required this.text});

  VoidCallback? onTap;
  String text;  

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,//to take width of full screen
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