import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';

import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class SettingPage extends StatefulWidget {
  static final id = "SettingPage";
  final String role;

  const SettingPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationsMuted = false;
  bool _darkTheme = false;
  bool _locationAccess = true;
  bool _autoUpdate = false;
  double _notificationVolume = 0.5;
  String _language = 'English';
  bool _analyticsEnabled = true;
  String name = '';
  String firstName = '';
  String lastName = '';
  final List<String> _languages = ['English', 'Arabic', 'French', 'Spanish'];

  @override
  void initState() {
    super.initState();
  }

  void _toggleNotifications(bool value) =>
      setState(() => _notificationsMuted = value);
  void _toggleTheme(bool value) => setState(() => _darkTheme = value);
  void _toggleLocation(bool value) => setState(() => _locationAccess = value);
  void _toggleAutoUpdate(bool value) => setState(() => _autoUpdate = value);
  void _changeVolume(double value) =>
      setState(() => _notificationVolume = value);
  void _changeLanguage(String? lang) {
    if (lang != null) setState(() => _language = lang);
  }

  void _toggleAnalytics(bool value) =>
      setState(() => _analyticsEnabled = value);
  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF1B4965);
    const tileRadius = BorderRadius.all(Radius.circular(12));

    Widget buildProfileAvatar() {
      final state = widget.role == "Radiologist"
          ? context.watch<DoctorProfileCubit>().state
          : context.watch<CenterProfileCubit>().state;
      String? imageUrl;
      String displayInitials = '';

      if (state is DoctorProfileSuccess) {
        imageUrl = state.doctor.imageUrl;
         firstName = state.doctor.firstName;
         lastName = state.doctor.lastName;

        if (firstName.isNotEmpty || lastName.isNotEmpty) {
          displayInitials =
              '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                  .toUpperCase();
        }
      } else if (state is CenterProfileSuccess) {
        imageUrl = state.center.imageUrl;
        name = state.center.centerName;
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
        onTap: () {},
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: (imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : null) as ImageProvider<Object>?,
          child: ((imageUrl == null || imageUrl.isEmpty))
              ? Text(
                  displayInitials,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                )
              : null,
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                buildProfileAvatar(),
                Text(
                  widget.role == "Radiologist" ? "Dr."+firstName + " " + lastName : name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(
                        role: widget.role,
                        index: 10,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: textColor),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: SwitchListTile(
              title: const Text('Mute Notifications',
                  style: TextStyle(color: textColor)),
              secondary: const Icon(Icons.notifications_off, color: textColor),
              value: _notificationsMuted,
              onChanged: _toggleNotifications,
              shape: RoundedRectangleBorder(borderRadius: tileRadius),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              title: const Text('Notification Volume',
                  style: TextStyle(color: textColor)),
              subtitle: Slider(
                value: _notificationVolume,
                onChanged: _notificationsMuted ? null : _changeVolume,
                activeColor: textColor,
              ),
              leading: const Icon(Icons.volume_up, color: textColor),
              shape: RoundedRectangleBorder(borderRadius: tileRadius),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: SwitchListTile(
              title:
                  const Text('Dark Theme', style: TextStyle(color: textColor)),
              secondary: const Icon(Icons.brightness_6, color: textColor),
              value: _darkTheme,
              onChanged: _toggleTheme,
              shape: RoundedRectangleBorder(borderRadius: tileRadius),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: SwitchListTile(
              title: const Text('Location Access',
                  style: TextStyle(color: textColor)),
              secondary: const Icon(Icons.location_on, color: textColor),
              value: _locationAccess,
              onChanged: _toggleLocation,
              shape: RoundedRectangleBorder(borderRadius: tileRadius),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: SwitchListTile(
              title: const Text('Auto Update Data',
                  style: TextStyle(color: textColor)),
              secondary: const Icon(Icons.update, color: textColor),
              value: _autoUpdate,
              onChanged: _toggleAutoUpdate,
              shape: RoundedRectangleBorder(borderRadius: tileRadius),
            ),
          ),
          const Divider(height: 32),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                leading: const Icon(Icons.language, color: textColor),
                title: const Text(
                  'App Language',
                  style: TextStyle(color: textColor),
                ),
                trailing: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _language,
                        iconEnabledColor: textColor,
                        items: _languages
                            .map((lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Text(
                                    lang,
                                    style: const TextStyle(color: textColor),
                                  ),
                                ))
                            .toList(),
                        onChanged: _changeLanguage,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: SwitchListTile(
              title: const Text('Allow Usage Analytics',
                  style: TextStyle(color: textColor)),
              secondary: const Icon(Icons.analytics, color: textColor),
              value: _analyticsEnabled,
              onChanged: _toggleAnalytics,
              shape: RoundedRectangleBorder(borderRadius: tileRadius),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.lock, color: textColor),
              title: const Text('Change Password',
                  style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () => Navigator.pushNamed(context, '/change_password'),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.fingerprint, color: textColor),
              title: const Text('Enable Fingerprint Unlock',
                  style: TextStyle(color: textColor)),
              trailing: Switch(
                value: false,
                onChanged: (v) {},
                activeColor: textColor,
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.cloud_upload, color: textColor),
              title: const Text('Backup & Restore Data',
                  style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () => Navigator.pushNamed(context, '/backup'),
            ),
          ),
          const Divider(height: 32),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip, color: textColor),
              title: const Text('Privacy Policy',
                  style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.open_in_new, color: textColor),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.description, color: textColor),
              title: const Text('Terms & Conditions',
                  style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.open_in_new, color: textColor),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: textColor),
              title:
                  const Text('About App', style: TextStyle(color: textColor)),
              trailing:
                  const Text('v1.0.0', style: TextStyle(color: textColor)),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: tileRadius),
            child: ListTile(
              leading: const Icon(Icons.logout, color: textColor),
              title: const Text('Logout', style: TextStyle(color: textColor)),
              onTap: () {
                // implement logout logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
