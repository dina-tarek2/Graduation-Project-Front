import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  static const String id = 'SettingPage';

  const SettingPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // userName: 'Jack Burton',
      body: Center(
        child: Text('Setting Page Content'),
      ), 
    );
  }
}