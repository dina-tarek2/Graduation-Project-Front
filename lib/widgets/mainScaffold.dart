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

// Enum for better type safety
enum UserRole { radiologyCenter, radiologist, admin }

// Extension for role string conversion
extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.radiologyCenter:
        return 'RadiologyCenter';
      case UserRole.radiologist:
        return 'Radiologist';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

// Helper class for UserRole conversion
class UserRoleHelper {
  static UserRole fromString(String role) {
    switch (role) {
      case 'RadiologyCenter':
        return UserRole.radiologyCenter;
      case 'Radiologist':
        return UserRole.radiologist;
      case 'Admin':
        return UserRole.admin;
      default:
        throw ArgumentError('Invalid role: $role');
    }
  }
}

// Constants for better maintainability
class AppConstants {
  static const int profileScreenIndex = 10;
  static const int notificationsScreenIndex = 11;
  static const double avatarRadius = 12.0;
  static const double headerHeight = 70.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}

class MainScaffold extends StatefulWidget {
  final UserRole role;
  final String title;
  final int initialIndex;

  static const String routeName = 'MainScaffold';

  const MainScaffold({
    super.key,
    required this.role,
    this.title = 'Dashboard',
    this.initialIndex = 0,
  });

  // Factory constructor for easy creation from string role
  factory MainScaffold.fromString({
    Key? key,
    required String role,
    String title = 'Dashboard',
    int initialIndex = 0,
  }) {
    return MainScaffold(
      key: key,
      role: UserRoleHelper.fromString(role),
      title: title,
      initialIndex: initialIndex,
    );
  }
  // Static method to find the MainScaffold state from context
  static MainScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainScaffoldState>();
  }

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold>
    with SingleTickerProviderStateMixin {
  // Static method to find the MainScaffold state from context
  static MainScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainScaffoldState>();
  }

  // Public method to reload notification icon
  void reloadNotifyIcon() {
    setState(() {});
  }

  // Public method to navigate to a specific screen
  void navigateToScreen(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  // Public getter for selected index
  int get selectedIndex => _selectedIndex;

  // Public setter for selected index (for backward compatibility)
  set selectedIndex(int index) {
    navigateToScreen(index);
  }

  late final List<Widget> _screens;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  File? _profileImage;
  final GlobalKey _notificationIconKey = GlobalKey();
  OverlayEntry? _notificationOverlay;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initializeAnimations();
    _initializeScreens();
    _initializeData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  void _initializeScreens() {
    _screens = _buildScreensForRole(widget.role);
  }

  List<Widget> _buildScreensForRole(UserRole role) {
    final userId = context.read<CenterCubit>().state;
    final userType = context.read<UserCubit>().state;

    switch (role) {
      case UserRole.radiologyCenter:
        return [
          const MedicalDashboardScreen(),
          const DicomsListPage(),
          ManageDoctorsPage(centerId: userId),
          ChatScreen(userId: userId, userType: userType),
          const AboutUsPage(),
          ContactScreen(role: role.value),
          SettingsPage(role: role.value),
        ];

      case UserRole.radiologist:
        return [
          const DoctorDashboard(),
          const RecordsListPage(),
          const NewDicomPage(),
          ChatScreenToDoctor(userId: userId, userType: userType),
          const AboutUsPage(),
          ContactScreen(role: role.value),
          SettingsPage(role: role.value),
        ];

      case UserRole.admin:
        return [
          const DashboardPage(),
          const RequestsPage(),
          ManageCentersPage(),
          const ManageDoctorsaPage(),
        ];
    }
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final centerId = context.read<CenterCubit>().state;

      // Initialize profile data
      context.read<DoctorProfileCubit>().fetchDoctorProfile(centerId);
      context.read<CenterProfileCubit>().fetchCenterProfile(centerId);

      // Initialize notifications
      context.read<NotificationCubit>().loadNotifications(centerId);

      // Setup toast context
      custom_toast.AdvancedNotification.setContext(context);
    });
  }

  // Navigation methods
  void _onNavigationItemSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _navigateToProfile() {
    _onNavigationItemSelected(AppConstants.profileScreenIndex);
  }

  void _handleLogout() {
    context.read<LoginCubit>().logout(context.read<CenterCubit>().state);
    Navigator.pushReplacementNamed(context, 'SigninPage');
  }

  // Profile avatar methods
  Widget _buildProfileAvatar() {
    return BlocBuilder<DoctorProfileCubit, dynamic>(
      builder: (context, doctorState) {
        return BlocBuilder<CenterProfileCubit, dynamic>(
          builder: (context, centerState) {
            final profileData = _getProfileData(doctorState, centerState);

            return GestureDetector(
              onTap: _navigateToProfile,
              child: CircleAvatar(
                radius: AppConstants.avatarRadius,
                backgroundColor: blue,
                backgroundImage: _getProfileImage(profileData.imageUrl),
                child: _getProfileImagePlaceholder(profileData),
              ),
            );
          },
        );
      },
    );
  }

  ProfileData _getProfileData(dynamic doctorState, dynamic centerState) {
    if (widget.role == UserRole.radiologist &&
        doctorState is DoctorProfileSuccess) {
      return ProfileData(
        imageUrl: doctorState.doctor.imageUrl,
        initials: _getInitials(
            doctorState.doctor.firstName, doctorState.doctor.lastName),
      );
    } else if (centerState is CenterProfileSuccess) {
      final nameParts = centerState.center.centerName.trim().split(' ');
      final first = nameParts.isNotEmpty ? nameParts[0] : '';
      final second = nameParts.length > 1 ? nameParts[1] : '';
      return ProfileData(
        imageUrl: centerState.center.imageUrl,
        initials: _getInitials(first, second),
      );
    }
    return const ProfileData();
  }

  String _getInitials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  ImageProvider<Object>? _getProfileImage(String? imageUrl) {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    }
    return null;
  }

  Widget? _getProfileImagePlaceholder(ProfileData profileData) {
    if (_profileImage == null &&
        (profileData.imageUrl == null || profileData.imageUrl!.isEmpty)) {
      return Text(
        profileData.initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return null;
  }

  // Notification methods
  int get _unreadNotificationCount {
    final state = context.read<NotificationCubit>().state;
    return state is NotificationLoaded ? state.unreadNotifications : 0;
  }

  Widget _buildNotificationIcon() {
    return BlocBuilder<NotificationCubit, dynamic>(
      builder: (context, state) {
        final unreadCount =
            state is NotificationLoaded ? state.unreadNotifications : 0;

        return GestureDetector(
          key: _notificationIconKey,
          onTap: _toggleNotificationsPopup,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  unreadCount > 0
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: blue,
                  size: 25,
                ),
                if (unreadCount > 0) _buildNotificationBadge(unreadCount),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationBadge(int count) {
    return Positioned(
      right: 16,
      top: -15,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: customTextStyle(
              12,
              FontWeight.w500,
              Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleNotificationsPopup() {
    if (_notificationOverlay == null) {
      _showNotificationsPopup();
    } else {
      _removeNotificationsPopup();
    }
  }

  void _showNotificationsPopup() {
    _removeNotificationsPopup();

    final renderBox =
        _notificationIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _notificationOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5,
        left: offset.dx - (size.width * 7.5),
        child: GestureDetector(
          onTap: _removeNotificationsPopup,
          child: const Material(
            color: Colors.transparent,
            child: NotificationsPopup(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_notificationOverlay!);
  }

  void _removeNotificationsPopup() {
    _notificationOverlay?.remove();
    _notificationOverlay = null;
  }

  // Screen management methods
  Widget _getCurrentScreen() {
    if (_selectedIndex < _screens.length) {
      return _screens[_selectedIndex];
    }

    final userId = context.read<CenterCubit>().state;

    switch (_selectedIndex) {
      case AppConstants.profileScreenIndex:
        return widget.role == UserRole.radiologist
            ? DoctorProfile(doctorId: userId, role: userId)
            : CenterProfile(centerId: userId, role: userId);

      case AppConstants.notificationsScreenIndex:
        return const NotificationsScreen();

      default:
        return _screens.isNotEmpty ? _screens[0] : const SizedBox.shrink();
    }
  }

  String _getCurrentScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        _updateNotificationsByType();
        return _getScreenTitleForIndex1();
      case 2:
        return _getScreenTitleForIndex2();
      case 3:
        return widget.role == UserRole.admin ? 'Manage Doctors' : 'Chat';
      case 4:
        return 'About Us';
      case 5:
        return 'Contact Us';
      case 6:
        return 'Settings';
      case AppConstants.profileScreenIndex:
        return 'My Profile';
      case AppConstants.notificationsScreenIndex:
        return 'Notifications';
      default:
        return widget.title;
    }
  }

  void _updateNotificationsByType() {
    context.read<NotificationCubit>().updataNotifyByType(
          context.read<CenterCubit>().state,
          "study",
        );
  }

  String _getScreenTitleForIndex1() {
    switch (widget.role) {
      case UserRole.radiologyCenter:
        return 'Upload Dicom';
      case UserRole.admin:
        return 'Requests';
      case UserRole.radiologist:
        return 'Dicom List';
    }
  }

  String _getScreenTitleForIndex2() {
    switch (widget.role) {
      case UserRole.radiologyCenter:
        return 'Manage Doctors';
      case UserRole.admin:
        return 'Manage Centers';
      case UserRole.radiologist:
        return 'New Reports';
    }
  }

  // UI Building methods
  Widget _buildHeader() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');
    final formattedDate = dateFormat.format(now);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        // border: Border.all(width: 0.5, color: blue),
      ),
      height: AppConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getCurrentScreenTitle(),
            style: customTextStyle(22, FontWeight.bold, blue),
          ),
          _buildHeaderActions(formattedDate),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(String formattedDate) {
    return Row(
      children: [
        Text(
          formattedDate,
          style: customTextStyle(12, FontWeight.w500, Colors.black54),
        ),
        const SizedBox(width: 10),
        _buildNotificationIcon(),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: _buildProfileAvatar(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarNavigation(
            selectedIndex: _selectedIndex,
            role: widget.role.value,
            onItemSelected: _onNavigationItemSelected,
            onLogout: _handleLogout,
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _getCurrentScreen(),
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

  @override
  void dispose() {
    _removeNotificationsPopup();
    _animationController.dispose();
    super.dispose();
  }
}

// Helper class for profile data
class ProfileData {
  final String? imageUrl;
  final String initials;

  const ProfileData({
    this.imageUrl,
    this.initials = '',
  });
}

// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduation_project_frontend/constants/colors.dart';
// import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
// import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
// import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
// import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';
// import 'package:graduation_project_frontend/cubit/login_cubit.dart';
// import 'package:graduation_project_frontend/screens/Admin/dashboard_page.dart';
// import 'package:graduation_project_frontend/screens/Admin/manage_centers_page.dart';
// import 'package:graduation_project_frontend/screens/Admin/manage_doctorsA_page.dart';
// import 'package:graduation_project_frontend/screens/Admin/requests_page.dart';
// import 'package:graduation_project_frontend/screens/Center/dicoms_list_page.dart';
// import 'package:graduation_project_frontend/screens/Center_dashboard.dart';
// import 'package:graduation_project_frontend/screens/Doctor/new_dicom_page.dart';
// import 'package:graduation_project_frontend/screens/Doctor/records_list_page.dart';
// import 'package:graduation_project_frontend/screens/SettingPage.dart';
// import 'package:graduation_project_frontend/screens/aboutUs.dart';
// import 'package:graduation_project_frontend/screens/Notifications/notifications_screen.dart';
// import 'package:graduation_project_frontend/screens/chatScreen.dart';
// import 'package:graduation_project_frontend/screens/chatScreenToDoctor.dart';
// import 'package:graduation_project_frontend/screens/contact_us_page.dart';
// import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
// import 'package:graduation_project_frontend/screens/manage_Doctor_page.dart';
// import 'package:graduation_project_frontend/screens/Doctor/doctor_profile.dart';
// import 'package:graduation_project_frontend/screens/Center/center_profile.dart';
// import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
// import 'package:graduation_project_frontend/widgets/custom_toast.dart' as custom_toast;
// import 'package:graduation_project_frontend/widgets/notifications_popup.dart';
// import 'package:graduation_project_frontend/widgets/sidebar_navigation.dart';
// import 'package:intl/intl.dart';

// // Enum for better type safety
// enum UserRole { radiologyCenter, radiologist, admin }

// // Extension for role string conversion
// extension UserRoleExtension on UserRole {
//   String get value {
//     switch (this) {
//       case UserRole.radiologyCenter:
//         return 'RadiologyCenter';
//       case UserRole.radiologist:
//         return 'Radiologist';
//       case UserRole.admin:
//         return 'Admin';
//     }
//   }

//   static UserRole fromString(String role) {
//     switch (role) {
//       case 'RadiologyCenter':
//         return UserRole.radiologyCenter;
//       case 'Radiologist':
//         return UserRole.radiologist;
//       case 'Admin':
//         return UserRole.admin;
//       default:
//         throw ArgumentError('Invalid role: $role');
//     }
//   }
// }

// // Constants for better maintainability
// class AppConstants {
//   static const int profileScreenIndex = 10;
//   static const int notificationsScreenIndex = 11;
//   static const double avatarRadius = 12.0;
//   static const double headerHeight = 70.0;
//   static const double borderRadius = 12.0;
//   static const Duration animationDuration = Duration(milliseconds: 300);
// }

// class MainScaffold extends StatefulWidget {
//   final UserRole role;
//   final String title;
//   final int initialIndex;
  
//   static const String routeName = 'MainScaffold';

//   const MainScaffold({
//     super.key,
//     required this.role,
//     this.title = 'Dashboard',
//     this.initialIndex = 0,
//   });

//   @override
//   State<MainScaffold> createState() => _MainScaffoldState();
// }

// class _MainScaffoldState extends State<MainScaffold> with SingleTickerProviderStateMixin {
//   late final List<Widget> _screens;
//   late final AnimationController _animationController;
//   late final Animation<double> _fadeAnimation;
  
//   File? _profileImage;
//   final GlobalKey _notificationIconKey = GlobalKey();
//   OverlayEntry? _notificationOverlay;
//   late int _selectedIndex;

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//     _initializeAnimations();
//     _initializeScreens();
//     _initializeData();
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: AppConstants.animationDuration,
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//     _animationController.forward();
//   }

//   void _initializeScreens() {
//     _screens = _buildScreensForRole(widget.role);
//   }

//   List<Widget> _buildScreensForRole(UserRole role) {
//     final userId = context.read<CenterCubit>().state;
//     final userType = context.read<UserCubit>().state;

//     switch (role) {
//       case UserRole.radiologyCenter:
//         return [
//           const MedicalDashboardScreen(),
//           const DicomsListPage(),
//           ManageDoctorsPage(centerId: userId),
//           ContactScreen(role: role.value),
//           ChatScreen(userId: userId, userType: userType),
//           const AboutUsPage(),
//           SettingsPage(role: role.value),
//         ];
      
//       case UserRole.radiologist:
//         return [
//           const DoctorDashboard(),
//           const RecordsListPage(),
//           const NewDicomPage(),
//           ContactScreen(role: role.value),
//           ChatScreenToDoctor(userId: userId, userType: userType),
//           const AboutUsPage(),
//           SettingsPage(role: role.value),
//         ];
      
//       case UserRole.admin:
//         return [
//           const DashboardPage(),
//           const RequestsPage(),
//           const ManageCentersPage(),
//           const ManageDoctorsaPage(),
//         ];
//     }
//   }

//   void _initializeData() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final centerId = context.read<CenterCubit>().state;
      
//       // Initialize profile data
//       context.read<DoctorProfileCubit>().fetchDoctorProfile(centerId);
//       context.read<CenterProfileCubit>().fetchCenterProfile(centerId);
      
//       // Initialize notifications
//       context.read<NotificationCubit>().loadNotifications(centerId);
      
//       // Setup toast context
//       custom_toast.AdvancedNotification.setContext(context);
//     });
//   }

//   // Navigation methods
//   void _onNavigationItemSelected(int index) {
//     if (_selectedIndex != index) {
//       setState(() {
//         _selectedIndex = index;
//       });
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }

//   void _navigateToProfile() {
//     _onNavigationItemSelected(AppConstants.profileScreenIndex);
//   }

//   void _handleLogout() {
//     context.read<LoginCubit>().logout(context.read<CenterCubit>().state);
//     Navigator.pushReplacementNamed(context, 'SigninPage');
//   }

//   // Profile avatar methods
//   Widget _buildProfileAvatar() {
//     return BlocBuilder<DoctorProfileCubit, dynamic>(
//       builder: (context, doctorState) {
//         return BlocBuilder<CenterProfileCubit, dynamic>(
//           builder: (context, centerState) {
//             final profileData = _getProfileData(doctorState, centerState);
            
//             return GestureDetector(
//               onTap: _navigateToProfile,
//               child: CircleAvatar(
//                 radius: AppConstants.avatarRadius,
//                 backgroundColor: blue,
//                 backgroundImage: _getProfileImage(profileData.imageUrl),
//                 child: _getProfileImagePlaceholder(profileData),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   ProfileData _getProfileData(dynamic doctorState, dynamic centerState) {
//     if (widget.role == UserRole.radiologist && doctorState is DoctorProfileSuccess) {
//       return ProfileData(
//         imageUrl: doctorState.doctor.imageUrl,
//         initials: _getInitials(doctorState.doctor.firstName, doctorState.doctor.lastName),
//       );
//     } else if (centerState is CenterProfileSuccess) {
//       final nameParts = centerState.center.centerName.trim().split(' ');
//       final first = nameParts.isNotEmpty ? nameParts[0] : '';
//       final second = nameParts.length > 1 ? nameParts[1] : '';
//       return ProfileData(
//         imageUrl: centerState.center.imageUrl,
//         initials: _getInitials(first, second),
//       );
//     }
//     return const ProfileData();
//   }

//   String _getInitials(String firstName, String lastName) {
//     final first = firstName.isNotEmpty ? firstName[0] : '';
//     final last = lastName.isNotEmpty ? lastName[0] : '';
//     return '$first$last'.toUpperCase();
//   }

//   ImageProvider<Object>? _getProfileImage(String? imageUrl) {
//     if (_profileImage != null) {
//       return FileImage(_profileImage!);
//     }
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       return NetworkImage(imageUrl);
//     }
//     return null;
//   }

//   Widget? _getProfileImagePlaceholder(ProfileData profileData) {
//     if (_profileImage == null && 
//         (profileData.imageUrl == null || profileData.imageUrl!.isEmpty)) {
//       return Text(
//         profileData.initials,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       );
//     }
//     return null;
//   }

//   // Notification methods
//   int get _unreadNotificationCount {
//     final state = context.read<NotificationCubit>().state;
//     return state is NotificationLoaded ? state.unreadNotifications : 0;
//   }

//   Widget _buildNotificationIcon() {
//     return BlocBuilder<NotificationCubit, dynamic>(
//       builder: (context, state) {
//         final unreadCount = state is NotificationLoaded ? state.unreadNotifications : 0;
        
//         return GestureDetector(
//           key: _notificationIconKey,
//           onTap: _toggleNotificationsPopup,
//           child: Container(
//             padding: const EdgeInsets.all(4),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Icon(
//                   unreadCount > 0
//                       ? Icons.notifications_active_rounded
//                       : Icons.notifications_none_rounded,
//                   color: blue,
//                   size: 25,
//                 ),
//                 if (unreadCount > 0) _buildNotificationBadge(unreadCount),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNotificationBadge(int count) {
//     return Positioned(
//       right: 16,
//       top: -15,
//       child: Container(
//         padding: const EdgeInsets.all(4),
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         constraints: const BoxConstraints(
//           minWidth: 16,
//           minHeight: 16,
//         ),
//         child: Center(
//           child: Text(
//             count.toString(),
//             style: customTextStyle(
//               12,
//               FontWeight.w500,
//               Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleNotificationsPopup() {
//     if (_notificationOverlay == null) {
//       _showNotificationsPopup();
//     } else {
//       _removeNotificationsPopup();
//     }
//   }

//   void _showNotificationsPopup() {
//     _removeNotificationsPopup();
    
//     final renderBox = _notificationIconKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) return;
    
//     final offset = renderBox.localToGlobal(Offset.zero);
//     final size = renderBox.size;

//     _notificationOverlay = OverlayEntry(
//       builder: (context) => Positioned(
//         top: offset.dy + size.height + 5,
//         left: offset.dx - (size.width * 7.5),
//         child: GestureDetector(
//           onTap: _removeNotificationsPopup,
//           child: const Material(
//             color: Colors.transparent,
//             child: NotificationsPopup(),
//           ),
//         ),
//       ),
//     );
    
//     Overlay.of(context).insert(_notificationOverlay!);
//   }

//   void _removeNotificationsPopup() {
//     _notificationOverlay?.remove();
//     _notificationOverlay = null;
//   }

//   // Screen management methods
//   Widget _getCurrentScreen() {
//     if (_selectedIndex < _screens.length) {
//       return _screens[_selectedIndex];
//     }
    
//     final userId = context.read<CenterCubit>().state;
    
//     switch (_selectedIndex) {
//       case AppConstants.profileScreenIndex:
//         return widget.role == UserRole.radiologist
//             ? DoctorProfile(doctorId: userId, role: userId)
//             : CenterProfile(centerId: userId, role: userId);
      
//       case AppConstants.notificationsScreenIndex:
//         return const NotificationsScreen();
      
//       default:
//         return _screens.isNotEmpty ? _screens[0] : const SizedBox.shrink();
//     }
//   }

//   String _getCurrentScreenTitle() {
//     switch (_selectedIndex) {
//       case 0:
//         return 'Dashboard';
//       case 1:
//         _updateNotificationsByType();
//         return _getScreenTitleForIndex1();
//       case 2:
//         return _getScreenTitleForIndex2();
//       case 3:
//         return widget.role == UserRole.admin ? 'Manage Doctors' : 'Contact Us';
//       case 4:
//         return 'Chat';
//       case 5:
//         return 'About Us';
//       case 6:
//         return 'Settings';
//       case AppConstants.profileScreenIndex:
//         return 'My Profile';
//       case AppConstants.notificationsScreenIndex:
//         return 'Notifications';
//       default:
//         return widget.title;
//     }
//   }

//   void _updateNotificationsByType() {
//     context.read<NotificationCubit>().updataNotifyByType(
//       context.read<CenterCubit>().state,
//       "study",
//     );
//   }

//   String _getScreenTitleForIndex1() {
//     switch (widget.role) {
//       case UserRole.radiologyCenter:
//         return 'Upload Dicom';
//       case UserRole.admin:
//         return 'Requests';
//       case UserRole.radiologist:
//         return 'Dicom List';
//     }
//   }

//   String _getScreenTitleForIndex2() {
//     switch (widget.role) {
//       case UserRole.radiologyCenter:
//         return 'Manage Doctors';
//       case UserRole.admin:
//         return 'Manage Centers';
//       case UserRole.radiologist:
//         return 'New Reports';
//     }
//   }

//   // UI Building methods
//   Widget _buildHeader() {
//     final now = DateTime.now();
//     final dateFormat = DateFormat('EEEE, d MMMM yyyy');
//     final formattedDate = dateFormat.format(now);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white70,
//         borderRadius: BorderRadius.circular(AppConstants.borderRadius),
//         border: Border.all(width: 0.5, color: blue),
//       ),
//       height: AppConstants.headerHeight,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             _getCurrentScreenTitle(),
//             style: customTextStyle(22, FontWeight.bold, blue),
//           ),
//           _buildHeaderActions(formattedDate),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderActions(String formattedDate) {
//     return Row(
//       children: [
//         Text(
//           formattedDate,
//           style: customTextStyle(12, FontWeight.w500, Colors.black54),
//         ),
//         const SizedBox(width: 10),
//         _buildNotificationIcon(),
//         const SizedBox(width: 8),
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppConstants.borderRadius),
//           ),
//           child: _buildProfileAvatar(),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           SidebarNavigation(
//             selectedIndex: _selectedIndex,
//             role: widget.role.value,
//             onItemSelected: _onNavigationItemSelected,
//             onLogout: _handleLogout,
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 _buildHeader(),
//                 Expanded(
//                   child: Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.all(20),
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: _getCurrentScreen(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _removeNotificationsPopup();
//     _animationController.dispose();
//     super.dispose();
//   }
// }

// // Helper class for profile data
// class ProfileData {
//   final String? imageUrl;
//   final String initials;

//   const ProfileData({
//     this.imageUrl,
//     this.initials = '',
//   });
// }