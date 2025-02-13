import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isExpanded;

  SidebarItem({required this.icon, required this.title, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kMinInteractiveDimension,
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.black),
        title: isExpanded ? Text(title, style: TextStyle(fontSize: 16)) : null,
        onTap: () {},
      ),
    );
  }
}