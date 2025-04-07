import 'package:flutter/material.dart';
class DashboardContent extends StatefulWidget {
  static String id = 'DashboardContent';
  
  DashboardContent({Key? key}) : super(key: key);

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}
class _DashboardContentState extends State<DashboardContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:Text(
        "Home Dashboard"
      )
    );
  }
}