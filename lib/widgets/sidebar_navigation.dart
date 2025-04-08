import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';

class SidebarNavigation extends StatefulWidget {
  final int selectedIndex;
  final String role;
  final Function(int) onItemSelected;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.role,
    required this.onItemSelected,
  });

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  bool isExpanded = true;

  void toggleSidebar() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? 250 : 80,
          decoration: BoxDecoration(
            color:  darkblue,
            borderRadius: const BorderRadius.all(
             Radius.circular(30),
             
            ),
            shape: BoxShape.rectangle
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black,
            //     spreadRadius: 1,
            //     blurRadius: 15,
            //     offset: const Offset(2, 0),
            //   ),
            // ],
          ),
          child: Column(
            children: [
              // Logo and toggle button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Row(
                  mainAxisAlignment: isExpanded
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    if (isExpanded)
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: darkBabyBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'R',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Radintal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkBabyBlue,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isExpanded ? Icons.chevron_left : Icons.chevron_right,
                          color: darkBabyBlue,
                          size: 22,
                        ),
                        onPressed: toggleSidebar,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu header
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'MAIN MENU',
                     style: customTextStyle(12, FontWeight.w600, darkBabyBlue),
                    ),
                  ),
                ),
        
              // Navigation items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: _buildNavigationItems(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems() {
    final List<Widget> items = [];
    
    // Common navigation items for RadiologCenter role
    if (widget.role == "RadiologyCenter") {
      items.addAll([
        buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
         buildNavItem(1, Icons.cloud_upload_rounded, 'Upload Dicom'),
        buildNavItem(2, Icons.groups_rounded, 'Manage Doctors'),
        buildNavItem(3, Icons.summarize_rounded, 'Center Reports'),
        buildNavItem(4, Icons.contact_mail_rounded, 'Contact Us'),
        buildNavItem(5, Icons.chat_bubble_rounded, 'Chat'),
      ]);
    } else if (widget.role == "Radiologist") {
      items.addAll([
        buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
        buildNavItem(1, Icons.cloud_upload_rounded, 'Dicom List'),
        // buildNavItem(2, Icons.person_rounded, 'Patients'),
        buildNavItem(3, Icons.medical_information_rounded, 'Medical Reports'),
        buildNavItem(4, Icons.contact_mail_rounded, 'Contact Us'),
        buildNavItem(5, Icons.chat_bubble_rounded, 'Chat'),
      ]);
    }
    
    // Settings divider and header
    if (isExpanded) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: darkBabyBlue,
            thickness: 1,
            height: 1,
          ),
        ),
      );
      
      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 10, top: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: darkBabyBlue,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      );
    }
    
    // Settings and Logout
    items.add(buildNavItem(6, Icons.settings_rounded, 'Settings'));
    items.add(const SizedBox(height: 20));
    items.add(buildNavItem(7, Icons.logout_rounded, 'Log Out'));
    
    return items;
  }

  Widget buildNavItem(int index, IconData icon, String title) {
    final isSelected = widget.selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => widget.onItemSelected(index),
        borderRadius: BorderRadius.circular(40),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          child: Row(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? darkBabyBlue
                      : Colors.transparent,
 borderRadius: const BorderRadius.only(
    topRight: Radius.circular(50),
    bottomRight: Radius.circular(50),
  ),                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected ? const Color(0xFF073042) : darkBabyBlue,
                    size: 20,
                  ),
                ),
              ),
              if (isExpanded)
                Expanded(
                  child: Text(
                    title,
                     style: customTextStyle(14, FontWeight.normal, darkBabyBlue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (isExpanded && isSelected)
                Container(
                  width: 5,
                  height: 25,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: darkBabyBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
            ],
          ),
          ),
        ), 
      );
    
  }
}