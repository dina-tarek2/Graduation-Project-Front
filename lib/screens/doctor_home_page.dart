import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  static const String id = 'HomePage';

  final String role;
  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: 'Dashboard',
      body: Center(
        child: Text('Home Page Content'),
      ),
      //  role: role,
    );
  }
}