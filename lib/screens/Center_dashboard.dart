import 'package:flutter/material.dart';
class CenterDashboard extends StatelessWidget {
    static const String id = 'CenterDashboard';
  final String role;

  const CenterDashboard({super.key,required this.role});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     
      body: Center(
        child: Text('CenterDashboard Content'),
      ), 
    );
  }
}