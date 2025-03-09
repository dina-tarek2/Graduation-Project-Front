import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/repositories/user_repository.dart';
import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/forget_password.dart';
import 'package:graduation_project_frontend/screens/manage_Doctor_page.dart';
import 'package:graduation_project_frontend/screens/medical_report_list.dart';
import 'package:graduation_project_frontend/screens/Doctor/doctor_profile.dart';
import 'package:graduation_project_frontend/widgets/sidebar_navigation.dart';

class MainScaffold extends StatefulWidget {
  final String role;
  final String title;
  static String id = 'MainScaffold';
  const MainScaffold({
    super.key,
    required this.role,
    this.title = 'Dashboard',
  });

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
      ];
    } else {
      // Default screens for other roles
      screens = [
        HomePage(role: widget.role),
        RecordsListPage(),
        MedicalReportsScreen(),
        ContactScreen(role: widget.role),
      ];
    }
  }

  void onItemSelected(int index) {
    // Only handle special navigation cases (like logout)
    if (index == 6) {
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
    return Scaffold(
      body: Row(
        children: [
          // Improved sidebar navigation
          SidebarNavigation(
            selectedIndex: selectedIndex,
            role: widget.role,
            onItemSelected: onItemSelected,
          ),

          // Content area
          Expanded(
            child: Column(
              children: [
                // App bar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getScreenTitle(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF073042),
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
                            child: GestureDetector(
                                child: const Icon(
                                  Icons.person_outline,
                                  color: darkBlue,
                                  size: 20,
                                ),
                                onTap: () {
                                  if (widget.role == "Radiologist") {
                                    onItemSelected(10);
                                  }
                                }),
                          )
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
    );
  }

  // Get the appropriate screen based on selectedIndex
  Widget _getSelectedScreen() {
    // Make sure we don't go out of bounds
    if (selectedIndex < screens.length) {
      return screens[selectedIndex];
    }

    // Fallback for settings or other screens not in the main list
    if (selectedIndex == 5) {
      return const Center(child: Text("Settings Screen"));
    }
    if (selectedIndex == 10) {
      return DoctorProfile(doctorId: context.read<CenterCubit>().state);
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
        return widget.role == "RadiologyCenter" ? 'Medical Reports' : '';
      case 4:
        return 'Contact Us';
      case 5:
        return 'Settings';
      case 10:
        return 'My Profile';
      default:
        return widget.title;
    }
  }
}
