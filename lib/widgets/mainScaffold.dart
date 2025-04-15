import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Admin/dashboard_page.dart';
import 'package:graduation_project_frontend/screens/Admin/manage_centers_page.dart';
import 'package:graduation_project_frontend/screens/Admin/manage_doctorsA_page.dart';
import 'package:graduation_project_frontend/screens/Admin/requests_page.dart';
import 'package:graduation_project_frontend/screens/Center/dicoms_list_page.dart';
import 'package:graduation_project_frontend/screens/Center/upload_page.dart';
import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
import 'package:graduation_project_frontend/screens/chatScreen.dart';
import 'package:graduation_project_frontend/screens/chatScreenToDoctor.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/dicom.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
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
  late final List<Widget> screens;
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.role == "RadiologyCenter") {
      screens = [
        CenterDashboard(role: widget.role),
        DicomsListPage(),
        // UploadButtonScreen(),
        // DicomListPage(),
        ManageDoctorsPage(centerId: context.read<CenterCubit>().state),
        MedicalReportsScreen(),
        ContactScreen(role: widget.role),
        ChatScreen(
          userId: context.read<CenterCubit>().state,
          userType: context.read<UserCubit>().state,
        ),
      ];
    } else if (widget.role == "Radiologist") {
      // Default screens for other roles
      screens = [
        DashboardContent(),
        RecordsListPage(),
        MedicalReportsScreen(),
        ContactScreen(role: widget.role),
        ContactScreen(role: widget.role),
        ChatScreenToDoctor(
          userId: context.read<CenterCubit>().state,
          userType: context.read<UserCubit>().state,
        ),
      ];
    } else {
      screens = [
        DashboardPage(),
        RequestsPage(),
        ManageCentersPage(),
        ManageDoctorsaPage(),
      ];
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

  Widget buildProfileAvatar() {
    final state;
    if (widget.role == "Radiologist") {
      state = context.watch<DoctorProfileCubit>().state;
    } else {
      state = context.watch<CenterCubit>().state;
    }
    String? imageUrl;
    String? doctorName;
    String? doctorName1;

    if (state is DoctorProfileSuccess) {
      imageUrl = state.doctor.imageUrl;
      doctorName = state.doctor.firstName;
      doctorName1 = state.doctor.lastName;
    } else {
      imageUrl = '';
      doctorName = '';
      doctorName1 = '';
    }

    return GestureDetector(
      onTap: () {
        if (widget.role == "Radiologist") {
          setState(() {
            selectedIndex = 10;
          });
        }
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: blue,
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : (imageUrl != null && imageUrl!.isNotEmpty
                ? NetworkImage(imageUrl!)
                : null),
        child: (_imageFile == null && (imageUrl == null || imageUrl!.isEmpty))
            ? Text(
                doctorName != null &&
                        doctorName.isNotEmpty &&
                        doctorName1 != null &&
                        doctorName1.isNotEmpty
                    ? doctorName.substring(0, 1).toUpperCase() +
                        doctorName1.substring(0, 1).toUpperCase()
                    : '',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarNavigation(
            selectedIndex: selectedIndex,
            role: widget.role,
            onItemSelected: onItemSelected,
          ),
          Expanded(
            child: Column(
              children: [
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildProfileAvatar(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen() {
    if (selectedIndex < screens.length) {
      return screens[selectedIndex];
    }

    // Fallback for settings or other screens not in the main list
    if (selectedIndex == 6) {
      return const Center(child: Text("Settings Screen"));
    }

    if (selectedIndex == 10) {
      return DoctorProfile(doctorId: context.read<CenterCubit>().state);
    }

    return screens[0];
  }

  String _getScreenTitle() {
    switch (selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return widget.role == "RadiologyCenter"
            ? 'Upload Dicom'
            : (widget.role == "Admin" ? 'Requests' : 'Dicom List');
      case 2:
        return widget.role == "RadiologyCenter"
            ? 'Manage Doctors'
            : (widget.role == "Admin" ? 'Manage Centers' : 'Chat');
      case 3:
        return widget.role == "RadiologyCenter"
            ? 'Medical Reports'
            : (widget.role == "Admin" ? 'Manage Doctors' : '');
      case 4:
        return 'Contact Us';
      case 5:
        return 'Chat App';
      case 6:
        return 'Settings';
      case 10:
        return 'My Profile';
      default:
        return widget.title;
    }
  }
}
