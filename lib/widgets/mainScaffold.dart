import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Admin/dashboard_page.dart';
import 'package:graduation_project_frontend/screens/Admin/manage_centers_page.dart';
import 'package:graduation_project_frontend/screens/Admin/manage_doctorsA_page.dart';
import 'package:graduation_project_frontend/screens/Admin/requests_page.dart';
import 'package:graduation_project_frontend/screens/Center/dicoms_list_page.dart';
import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
import 'package:graduation_project_frontend/screens/Doctor/new_dicom_page.dart';
import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
import 'package:graduation_project_frontend/screens/SettingPage.dart';
import 'package:graduation_project_frontend/screens/aboutUs.dart';
import 'package:graduation_project_frontend/screens/Notifications/notifications_screen.dart';
import 'package:graduation_project_frontend/screens/chatScreen.dart';
import 'package:graduation_project_frontend/screens/chatScreenToDoctor.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/manage_Doctor_page.dart';
import 'package:graduation_project_frontend/screens/Doctor/doctor_profile.dart';
import 'package:graduation_project_frontend/screens/Center/center_profile.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart'
    as custom_toast;
import 'package:graduation_project_frontend/widgets/notifications_popup.dart';
import 'package:graduation_project_frontend/widgets/sidebar_navigation.dart';
import 'package:intl/intl.dart';
// import 'package:graduation_project_frontend/widgets/build_profile_avater.dart';

class MainScaffold extends StatefulWidget {
  final String role;
  final String title;
  static String id = 'MainScaffold';
  final int index;
  const MainScaffold({
    super.key,
    required this.role,
    this.title = 'Dashboard',
    this.index = 0,
  });

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  late final List<Widget> screens;
  File? _imageFile;
  String imageUrl = "";
  // GlobalKey to locate the notifications icon for overlay positioning
  final GlobalKey _notificationIconKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index;
    // Fetch doctor profile if role is Radiologist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProfileCubit>().fetchDoctorProfile(
            context.read<CenterCubit>().state,
          );
      context.read<CenterProfileCubit>().fetchCenterProfile(
            context.read<CenterCubit>().state,
          );
      context.read<NotificationCubit>().loadNotifications(
            context.read<CenterCubit>().state,
          );

      custom_toast.AdvancedNotification.setContext(context);
      reloadNotifyIcon();
    });

    // Initialize screens based on role
    if (widget.role == "RadiologyCenter") {
      screens = [
        MedicalDashboardScreen(),
        DicomsListPage(),
        ManageDoctorsPage(centerId: context.read<CenterCubit>().state),
        ContactScreen(role: widget.role),
        ChatScreen(
          userId: context.read<CenterCubit>().state,
          userType: context.read<UserCubit>().state,
        ),
        AboutUsPage(),
        SettingPage(
          role: widget.role,
        ),
      ];
    } else if (widget.role == "Radiologist") {
      // Default screens for other roles
      screens = [
        DoctorDashboard(),
        RecordsListPage(),
        NewDicomPage(),
        ContactScreen(role: widget.role),
        ChatScreenToDoctor(
          userId: context.read<CenterCubit>().state,
          userType: context.read<UserCubit>().state,
        ),
        AboutUsPage(),
        SettingPage(
          role: widget.role,
          
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

  void reloadNotifyIcon() {
    setState(() {});
  }

  // Handle navigation from the sidebar
  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Build the profile avatar widget
  Widget buildProfileAvatar() {
    final state = widget.role == "Radiologist"
        ? context.watch<DoctorProfileCubit>().state
        : context.watch<CenterProfileCubit>().state;
    String? imageUrl;
    String displayInitials = '';

    if (state is DoctorProfileSuccess) {
      imageUrl = state.doctor.imageUrl;
      final firstName = state.doctor.firstName;
      final lastName = state.doctor.lastName;
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        displayInitials =
            '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                .toUpperCase();
      }
    } else if (state is CenterProfileSuccess) {
      imageUrl = state.center.imageUrl;
      final nameParts = state.center.centerName.trim().split(' ');
      if (nameParts.isNotEmpty) {
        final first = nameParts.isNotEmpty ? nameParts[0] : '';
        final second = nameParts.length > 1 ? nameParts[1] : '';
        displayInitials =
            '${first.isNotEmpty ? first[0] : ''}${second.isNotEmpty ? second[0] : ''}'
                .toUpperCase();
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = 10;
        });
      },
      child: CircleAvatar(
        radius: 12,
        backgroundColor: blue,
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : (imageUrl != null && imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null) as ImageProvider<Object>?,
        child: (_imageFile == null && (imageUrl == null || imageUrl.isEmpty))
            ? Text(
                displayInitials,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              )
            : null,
      ),
    );
  }

  int get _unreadNotificationCount {
    final stateNot = context.read<NotificationCubit>().state;
    if (stateNot is NotificationLoaded) {
      return stateNot.unreadNotifications;
    }
    return 0;
  }

  // Show the notifications popup overlay
// Show the notifications popup overlay
  void _showNotificationsPopup() {
    _removeNotificationsPopup();
    final RenderBox renderBox =
        _notificationIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5,
        left: offset.dx - (size.width * 7.5),
        child: GestureDetector(
          onTap: () {
            // Close the popup if the user taps outside
            _removeNotificationsPopup();
          },
          child: Material(
            color:
                Colors.transparent, // To ensure the background is transparent
            child: const NotificationsPopup(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Remove the notifications popup overlay
  void _removeNotificationsPopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeNotificationsPopup();
    super.dispose();
  }

  // Return the currently selected screen
  Widget _getSelectedScreen() {
    if (selectedIndex < screens.length) {
      return screens[selectedIndex];
    }
    if (selectedIndex == 10) {
      if (widget.role == "Radiologist") {
        return DoctorProfile(
            doctorId: context.read<CenterCubit>().state,
            role: context.read<CenterCubit>().state);
      } else {
        return CenterProfile(
            centerId: context.read<CenterCubit>().state,
            role: context.read<CenterCubit>().state);
      }
    }
    if (selectedIndex == 11) {
      return NotificationsScreen();
    }
    return screens[0];
  }

  // Return the title based on the selected screen

  String _getScreenTitle() {
    switch (selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        context
            .read<NotificationCubit>()
            .updataNotifyByType(context.read<CenterCubit>().state, "study");
        return widget.role == "RadiologyCenter"
            ? 'Upload Dicom'
            : (widget.role == "Admin" ? 'Requests' : 'Dicom List');
      case 2:
        return widget.role == "RadiologyCenter"
            ? 'Manage Doctors'
            : (widget.role == "Admin" ? 'Manage Centers' : 'New Rpeorts');
      case 3:
        return 'Contact Us';
      case 4:
        return 'Chat';
      case 5:
        return 'About Us';
      case 6:
        return 'Setting';
      case 10:
        return 'My Profile';
      case 11:
        return 'Notifications';
      default:
        return widget.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat dateFormat = DateFormat('EEEE, d MMMM yyyy');
    final String formattedDate = dateFormat.format(now);
    return Scaffold(
      body: Row(
        children: [
          SidebarNavigation(
            selectedIndex: selectedIndex,
            role: widget.role,
            onItemSelected: onItemSelected,
            onLogout: () {
              context
                  .read<LoginCubit>()
                  .logout(context.read<CenterCubit>().state);
              Navigator.pushReplacementNamed(context, 'SigninPage');
            },
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 0.5, color: blue),
                    // boxShadow: ,
                  ),
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getScreenTitle(),
                        style: customTextStyle(
                          22,
                          FontWeight.bold,
                          blue,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            formattedDate,
                            style: customTextStyle(
                              12,
                              FontWeight.w500,
                              Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              // color: sky,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          GestureDetector(
                            key: _notificationIconKey,
                            onTap: () {
                              if (_overlayEntry == null) {
                                _showNotificationsPopup();
                              } else {
                                _removeNotificationsPopup();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              // decoration: BoxDecoration(
                              //   color: _unreadNotificationCount > 0
                              //       ? lightBlue
                              //       : sky, // تغيير اللون بناءً على الحالة
                              //   borderRadius: BorderRadius.circular(12),
                              // ),
                              child: Stack(
                                clipBehavior:
                                    Clip.none, // لتجنب تجاوز العداد للحدود
                                children: [
                                  Icon(
                                    _unreadNotificationCount > 0
                                        ? Icons.notifications_active_rounded
                                        : Icons.notifications_none_rounded,
                                    color: blue,
                                    size: 25,
                                  ),
                                  if (_unreadNotificationCount > 0)
                                    Positioned(
                                      right: 16,
                                      top: -15,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _unreadNotificationCount.toString(),
                                            style: customTextStyle(
                                              12,
                                              FontWeight.w500,
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: buildProfileAvatar()),
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
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
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
}
