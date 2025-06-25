import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class SettingsPage extends StatefulWidget {
  static final id = "settings_page";
  final String role;

  const SettingsPage({
    super.key,
    required this.role,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Settings state
  final _settingsNotifier = _SettingsNotifier();

  @override
  void dispose() {
    _settingsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: ValueListenableBuilder<_SettingsState>(
        valueListenable: _settingsNotifier,
        builder: (context, settings, _) {
          return CustomScrollView(
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: _ProfileHeader(role: widget.role),
              ),

              // Settings Sections
              SliverList(
                delegate: SliverChildListDelegate([
                  _SettingsSection(
                    title: 'Notifications',
                    children: [
                      _SettingsTile.switchTile(
                        icon: Icons.notifications_outlined,
                        title: 'Push Notifications',
                        subtitle: 'Receive app notifications',
                        value: settings.notificationsEnabled,
                        onChanged: (value) =>
                            _settingsNotifier.updateNotifications(value),
                      ),
                      _SettingsTile.sliderTile(
                        icon: Icons.volume_up_outlined,
                        title: 'Notification Volume',
                        value: settings.notificationVolume,
                        enabled: settings.notificationsEnabled,
                        onChanged: (value) =>
                            _settingsNotifier.updateVolume(value),
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: 'Appearance',
                    children: [
                      _SettingsTile.switchTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme',
                        value: settings.darkTheme,
                        onChanged: (value) =>
                            _settingsNotifier.updateTheme(value),
                      ),
                      _SettingsTile.dropdownTile(
                        icon: Icons.language_outlined,
                        title: 'Language',
                        value: settings.language,
                        items: const ['English', 'Arabic', 'French', 'Spanish'],
                        onChanged: (value) =>
                            _settingsNotifier.updateLanguage(value),
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: 'Account',
                    children: [
                      _SettingsTile.navigationTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        onTap: () => _navigateToChangePassword(context),
                      ),
                    ],
                  ),
                  _SettingsSection(
                    title: 'About',
                    children: [
                      _SettingsTile.navigationTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () => _openPrivacyPolicy(),
                      ),
                      _SettingsTile.navigationTile(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        onTap: () => _openTerms(),
                      ),
                      _SettingsTile.infoTile(
                        icon: Icons.info_outline,
                        title: 'App Version',
                        value: 'v1.0.0',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.pushNamed(context, '/change_password');
  }

  void _openPrivacyPolicy() {
    // Implement privacy policy opening
  }

  void _openTerms() {
    // Implement terms opening
  }
}

class _ProfileHeader extends StatelessWidget {
  final String role;

  const _ProfileHeader({required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildProfileAvatar(context),
          const SizedBox(height: 16),
          _buildUserInfo(context),
          const SizedBox(height: 16),
          _buildEditButton(context, theme),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    final state = role == "Radiologist"
        ? context.watch<DoctorProfileCubit>().state
        : context.watch<CenterProfileCubit>().state;

    String? imageUrl;
    String displayInitials = '';

    if (state is DoctorProfileSuccess) {
      final doctor = state.doctor;
      imageUrl = doctor.imageUrl;
      displayInitials = _getInitials(doctor.firstName, doctor.lastName);
    } else if (state is CenterProfileSuccess) {
      final center = state.center;
      imageUrl = center.imageUrl;
      displayInitials = _getCenterInitials(center.centerName);
    }

    return Hero(
      tag: 'profile_avatar',
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage:
            imageUrl?.isNotEmpty == true ? NetworkImage(imageUrl!) : null,
        child: imageUrl?.isEmpty != false
            ? Text(
                displayInitials,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final state = role == "Radiologist"
        ? context.watch<DoctorProfileCubit>().state
        : context.watch<CenterProfileCubit>().state;

    String displayName = '';
    String? subtitle;

    if (state is DoctorProfileSuccess) {
      final doctor = state.doctor;
      displayName = 'Dr. ${doctor.firstName} ${doctor.lastName}';
      subtitle = 'Radiologist';
    } else if (state is CenterProfileSuccess) {
      displayName = state.center.centerName;
      subtitle = 'Medical Center';
    }

    return Column(
      children: [
        Text(
          displayName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, ThemeData theme) {
    return FilledButton.tonalIcon(
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainScaffold(role: role, index: 10),
        ),
      ),
      icon: const Icon(Icons.edit_outlined, size: 18),
      label: const Text('Edit Profile'),
    );
  }

  String _getInitials(String firstName, String lastName) {
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }

  String _getCenterInitials(String centerName) {
    final parts = centerName.trim().split(' ');
    final first = parts.isNotEmpty ? parts[0] : '';
    final second = parts.length > 1 ? parts[1] : '';
    return '${first.isNotEmpty ? first[0] : ''}${second.isNotEmpty ? second[0] : ''}'
        .toUpperCase();
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  factory _SettingsTile.switchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  factory _SettingsTile.sliderTile({
    required IconData icon,
    required String title,
    required double value,
    bool enabled = true,
    required ValueChanged<double> onChanged,
  }) {
    return _SettingsTile(
      icon: icon,
      title: title,
      trailing: SizedBox(
        width: 150,
        child: Slider.adaptive(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }

  factory _SettingsTile.dropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return _SettingsTile(
      icon: icon,
      title: title,
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (value) => value != null ? onChanged(value) : null,
      ),
    );
  }

  factory _SettingsTile.navigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return _SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      titleColor: titleColor,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  factory _SettingsTile.infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return _SettingsTile(
      icon: icon,
      title: title,
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: titleColor ?? theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Settings State Management
class _SettingsState {
  final bool notificationsEnabled;
  final double notificationVolume;
  final bool darkTheme;
  final bool locationAccess;
  final bool autoUpdate;
  final String language;
  final bool analyticsEnabled;
  final bool biometricEnabled;

  const _SettingsState({
    this.notificationsEnabled = true,
    this.notificationVolume = 0.5,
    this.darkTheme = false,
    this.locationAccess = true,
    this.autoUpdate = false,
    this.language = 'English',
    this.analyticsEnabled = true,
    this.biometricEnabled = false,
  });

  _SettingsState copyWith({
    bool? notificationsEnabled,
    double? notificationVolume,
    bool? darkTheme,
    bool? locationAccess,
    bool? autoUpdate,
    String? language,
    bool? analyticsEnabled,
    bool? biometricEnabled,
  }) {
    return _SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationVolume: notificationVolume ?? this.notificationVolume,
      darkTheme: darkTheme ?? this.darkTheme,
      locationAccess: locationAccess ?? this.locationAccess,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      language: language ?? this.language,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

class _SettingsNotifier extends ValueNotifier<_SettingsState> {
  _SettingsNotifier() : super(const _SettingsState());

  void updateNotifications(bool enabled) {
    value = value.copyWith(notificationsEnabled: enabled);
  }

  void updateVolume(double volume) {
    value = value.copyWith(notificationVolume: volume);
  }

  void updateTheme(bool isDark) {
    value = value.copyWith(darkTheme: isDark);
  }

  void updateLocation(bool enabled) {
    value = value.copyWith(locationAccess: enabled);
  }

  void updateAutoSync(bool enabled) {
    value = value.copyWith(autoUpdate: enabled);
  }

  void updateLanguage(String language) {
    value = value.copyWith(language: language);
  }

  void updateAnalytics(bool enabled) {
    value = value.copyWith(analyticsEnabled: enabled);
  }

  void updateBiometric(bool enabled) {
    value = value.copyWith(biometricEnabled: enabled);
  }
}
