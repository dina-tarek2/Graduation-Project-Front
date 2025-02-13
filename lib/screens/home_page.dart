import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/widgets/sidebar_Item.dart';
class HomePage extends StatefulWidget {
      static String id = 'HomePage';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
      bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body:  Row(
        children: [
          SizedBox(
            height: double.infinity,
            child: AnimatedContainer(
             height: double.infinity, 
             constraints: BoxConstraints(minHeight: 100),
              duration: Duration(milliseconds: 300),
              width: isExpanded ? 200 : 70, 
              color: Colors.grey[200], 
              child: Column(
                
                children: [
                  SizedBox(height: 20), 
            
                  Align(
                    alignment: isExpanded ? Alignment.centerRight : Alignment.center,
                    child: IconButton(
                      icon: Icon(isExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded; 
                        });
                      },
                    ),
                  ),
            
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SidebarItem(icon: Icons.home, title: "Home", isExpanded: isExpanded),
                        SidebarItem(icon: Icons.person, title: "Profile", isExpanded: isExpanded),
                        SidebarItem(icon: Icons.settings, title: "Settings", isExpanded: isExpanded),
                        SidebarItem(icon: Icons.info, title: "About", isExpanded: isExpanded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}