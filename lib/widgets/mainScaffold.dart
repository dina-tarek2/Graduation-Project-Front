import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
import 'package:graduation_project_frontend/screens/chatScreen.dart';
import 'package:graduation_project_frontend/screens/chatScreenToDoctor.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/manage_Doctor_page.dart';
import 'package:graduation_project_frontend/screens/medical_report_list.dart';
import 'package:graduation_project_frontend/widgets/sidebar_navigation.dart';

class MainScaffold extends StatefulWidget {
  final String role;
  final String title;
  static String id ='MainScaffold';
  const MainScaffold({
    Key? key,
    required this.role,
    this.title = 'Dashboard',
  }) : super(key: key);

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  
  int selectedIndex = 0;

  // Define screens based on role (can be expanded based on roles)
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    
    // Initialize screens based on role
    if (widget.role == "RadiologyCenter") {
      screens = [
        CenterDashboard(role: widget.role),
        DicomListPage(),
        ManageDoctorsPage(centerId: context.read<CenterCubit>().state),
        MedicalReportsScreen(),
        ContactScreen(role: widget.role),
ChatScreen(userId: context.read<CenterCubit>().state,userType: context.read<UserCubit>().state ,),      ];
    } else{
      // Default screens for other roles
      screens = [
        // HomePage(role: widget.role),
        RecordsListPage(),
        DashboardContent(),
        MedicalReportsScreen(),
        ContactScreen(role: widget.role),
        ContactScreen(role: widget.role),
ChatScreenToDoctor(userId: context.read<CenterCubit>().state,userType: context.read<UserCubit>().state ,),      ];
    }
  }

  void onItemSelected(int index) {
    // Only handle special navigation cases (like logout)
    if (index == 7) {
      context.read<LoginCubit>().logout(context.read<CenterCubit>().state);
       Navigator.pushReplacementNamed(context, 'SigninPage');
      return;
    }

    
    // For regular screen switching within the main scaffold
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          
          children: [
            // Improved sidebar navigation
            Container(
              color: Colors.white,
              child: SidebarNavigation(
                selectedIndex: selectedIndex,
                role: widget.role,
                onItemSelected: onItemSelected,
              ),
            ),
            
            // Content area
            Expanded(
              child: Column(
                children: [
                  // App bar
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getScreenTitle(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Blue,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: sky,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFF073042),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: sky,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: darkBlue,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: _getSelectedScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get the appropriate screen based on selectedIndex
  Widget _getSelectedScreen() {
    // Make sure we don't go out of bounds
    if (selectedIndex < screens.length) {
      return screens[selectedIndex];
    }
    
    // Fallback for settings or other screens not in the main list
    if (selectedIndex == 6) {
      return const Center(child: Text("Settings Screen"));
    }
    
    return screens[0]; // Default to first screen
  }

  // Get the title for the current screen
  String _getScreenTitle() {
    switch (selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return widget.role == "RadiologyCenter" ? 'Upload Dicom' : 'Dicom List';
      case 2:
        return widget.role == "RadiologyCenter" ? 'Manage Doctors' : 'Patients';
      case 3:
        return widget.role == "RadiologyCenter" ?  'Medical Reports':'';
      case 4:
        return 'Contact Us';
      case 5:
        return 'Chat App';
        case 6:
        return 'Settings';
      default:
        return widget.title;
    }
  }
}