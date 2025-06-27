import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'dart:async';

import 'package:graduation_project_frontend/screens/welcomePage.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Duration of the splash screen animation
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start animation
    _animationController.forward();

    // Navigate to main screen after delay
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or icon
              Image.asset(
                'assets/images/logo512.png', // Replace with your app logo
                width: 400,
                height: 200,
              ),
              SizedBox(height: 10),

              // App name with radiology theme
              Text('Radiology Intelligent',
                  style: customTextStyle(32, FontWeight.w500, blue)),

              SizedBox(height: 10),

              // Tagline
              Text('Advanced DICOM Analysis & Diagnostic Support',
                  style: customTextStyle(16, FontWeight.w400, blue)),

              SizedBox(height: 25),

              // Loading indicator
              Container(
                width: 250,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),

              SizedBox(height: 20),

              // Loading text
              Text('Initializing AI Components...',
                  style: customTextStyle(14, FontWeight.w400, blue)),
            ],
          ),
        ),
      ),
    );
  }
}
