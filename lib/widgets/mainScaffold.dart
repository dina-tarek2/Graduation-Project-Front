import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
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
import 'package:graduation_project_frontend/screens/Notifications/notifications_screen.dart';
import 'package:graduation_project_frontend/screens/chatScreen.dart';
import 'package:graduation_project_frontend/screens/chatScreenToDoctor.dart';
import 'package:graduation_project_frontend/screens/contact_us_page.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/manage_Doctor_page.dart';
import 'package:graduation_project_frontend/screens/medical_report_list.dart';
import 'package:graduation_project_frontend/screens/Doctor/doctor_profile.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart'
    as custom_toast;
import 'package:graduation_project_frontend/widgets/notifications_popup.dart';
import 'package:graduation_project_frontend/widgets/sidebar_navigation.dart';

class MainScaffold extends StatefulWidget {
  final String role;
  final String title;
  static String id = 'MainScaffold';
  final int Index;
  const MainScaffold({
    super.key,
    required this.role,
    this.title = 'Dashboard',
    this.Index = 0,
  });

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  late final List<Widget> screens;
  File? _imageFile;

  // GlobalKey to locate the notifications icon for overlay positioning
  final GlobalKey _notificationIconKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.Index;
    // Fetch doctor profile if role is Radiologist
    context.read<DoctorProfileCubit>().fetchDoctorProfile(
          context.read<CenterCubit>().state,
        );
    // Fetch notifications>
    context.read<NotificationCubit>().loadNotifications(
          context.read<CenterCubit>().state,
        );
    print(
        "////////////////////////////////////// ${context.read<CenterCubit>().state}");
    custom_toast.AdvancedNotification.setContext(context);
    // Initialize screens based on role
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

  void reloadNotifyIcon() {
    setState(() {});
  }

  // Handle navigation from the sidebar
  void onItemSelected(int index) {
    if (index == 7) {
      context.read<LoginCubit>().logout(context.read<CenterCubit>().state);
      Navigator.pushReplacementNamed(context, 'SigninPage');
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  // Build the profile avatar widget
  Widget buildProfileAvatar() {
    final state;
    state = context.watch<DoctorProfileCubit>().state;
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
        setState(() {
          selectedIndex = 10;
        });
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: blue,
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : (imageUrl != null && imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null) as ImageProvider<Object>?,
        child: (_imageFile == null && (imageUrl == null || imageUrl.isEmpty))
            ? Text(
                (doctorName != null &&
                        doctorName.isNotEmpty &&
                        doctorName1 != null &&
                        doctorName1.isNotEmpty)
                    ? doctorName.substring(0, 1).toUpperCase() +
                        doctorName1.substring(0, 1).toUpperCase()
                    : '',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              )
            : null,
      ),
    );
  }

  IconData _getNotificationIcon() {
    if (_unreadNotificationCount > 0 && selectedIndex != 11) {
      return Icons.notifications_active_rounded;
    }
    return Icons.notifications_none_rounded;
  }

// دالة للحصول على اللون المناسب لأيقونة الإشعارات
  Color _getIconBackgroundColor() {
    if (_unreadNotificationCount > 0 && selectedIndex != 11) {
      return Colors.orangeAccent; // اللون إذا كانت هناك إشعارات غير مقروءة
    }
    return sky;
  }

// دالة لحساب عدد الإشعارات غير المقروءة
  int get _unreadNotificationCount {
    final state = context.read<NotificationCubit>().state;
    if (state is NotificationLoaded) {
      return state.notifications.where((notif) => !notif.isRead).length;
    }
    return 0;
  }

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
        child: const NotificationsPopup(),
      ),
    );
    Overlay.of(context)!.insert(_overlayEntry!);
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
    if (selectedIndex == 6) {
      return const Center(child: Text("Settings Screen"));
    }
    if (selectedIndex == 10) {
      return DoctorProfile(
          doctorId: context.read<CenterCubit>().state,
          role: context.read<CenterCubit>().state);
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
        return widget.role == "RadiologyCenter" ? 'Upload Dicom' : 'Dicom List';
      case 2:
        return widget.role == "RadiologyCenter" ? 'Manage Doctors' : 'Chat';
      case 3:
        return widget.role == "RadiologyCenter" ? 'Medical Reports' : '';
      case 4:
        return 'Contact Us';
      case 5:
        return 'Chat App';
      case 6:
        return 'Settings';
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
                          color: darkblue,
                        ),
                      ),
                      Row(
                        children: [
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    _getIconBackgroundColor(), // تغيير اللون بناءً على الحالة
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                clipBehavior:
                                    Clip.none, // لتجنب تجاوز العداد للحدود
                                children: [
                                  Icon(
                                    _getNotificationIcon(), // تغيير الأيقونة بناءً على الحالة
                                    color: Color(0xFF073042),
                                    size: 20,
                                  ),
                                  if (_unreadNotificationCount > 0 &&
                                      selectedIndex !=
                                          11) // عرض العداد إذا كان هناك إشعارات غير مقروءة
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
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
<<<<<<< HEAD
=======

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
>>>>>>> dad68791135ccac6a7503397d7db3f025d44906c
}
