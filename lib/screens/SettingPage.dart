import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';
import 'package:graduation_project_frontend/cubit/setting_cubit.dart';
import 'package:graduation_project_frontend/screens/privacy_policy_page.dart';
import 'package:graduation_project_frontend/screens/terms_conditions_page.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart'; // إضافة للحفظ المحلي

class SettingsPage extends StatefulWidget {
  static const String id = '/settings';
  final String centerId;
  final String role;

  const SettingsPage({
    super.key,
    required this.role,
    required this.centerId,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Settings state
  final _settingsNotifier = _SettingsNotifier();

  // Define the custom blue color
  static const Color customBlue = Color(0xFF1B4965);

  @override
  void initState() {
    super.initState();
    // جلب بيانات المحفظة إذا كان المستخدم مركز طبي
    if (widget.role == "RadiologyCenter") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SettingCubit>().getWalletBalance(widget.centerId);
      });
    }

    // تحميل الإعدادات المحفوظة
    _loadSettings();
  }

  // تحميل الإعدادات من SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;
      final notificationVolume = prefs.getDouble('notification_volume') ?? 0.5;
      final urgentDeadlineHours = prefs.getInt('urgent_deadline_hours') ?? 2;
      final normalDeadlineHours = prefs.getInt('normal_deadline_hours') ?? 24;

      _settingsNotifier.updateSettings(
        notificationsEnabled: notificationsEnabled,
        notificationVolume: notificationVolume,
        urgentDeadlineHours: urgentDeadlineHours,
        normalDeadlineHours: normalDeadlineHours,
      );
    } catch (e) {
      print('Failed to load settings: $e');
    }
  }

  // حفظ الإعدادات في SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settings = _settingsNotifier.value;

      await prefs.setBool(
          'notifications_enabled', settings.notificationsEnabled);
      await prefs.setDouble('notification_volume', settings.notificationVolume);
      await prefs.setInt('urgent_deadline_hours', settings.urgentDeadlineHours);
      await prefs.setInt('normal_deadline_hours', settings.normalDeadlineHours);
    } catch (e) {
      print('Failed to save settings: $e');
    }
  }

  @override
  void dispose() {
    _settingsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // إضافة listener للاستماع لحالة الدفع
          BlocListener<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is PaymentInitiated) {
                _launchPaymentURL(state.iframeURL);
              } else if (state is SettingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: ValueListenableBuilder<_SettingsState>(
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
                    // Wallet Section - Only for RadiologyCenter
                    if (widget.role == "RadiologyCenter") ...[
                      _WalletSection(centerId: widget.centerId),
                      _DeadlineSection(
                        urgentDeadlineHours: settings.urgentDeadlineHours,
                        normalDeadlineHours: settings.normalDeadlineHours,
                        onUrgentChanged: (value) {
                          _settingsNotifier.updateUrgentDeadline(value);
                          _saveSettings();
                        },
                        onNormalChanged: (value) {
                          _settingsNotifier.updateNormalDeadline(value);
                          _saveSettings();
                        },
                      ),
                    ],

                    _SettingsSection(
                      title: 'Notifications',
                      children: [
                        _SettingsTile.switchTile(
                          icon: Icons.volume_up_outlined,
                          title: 'Notification Sounds',
                          subtitle: 'Play sound for notifications',
                          value: settings.notificationsEnabled &&
                              settings.notificationVolume > 0.0,
                          onChanged: (value) {
                            if (value) {
                              // إذا تم تفعيل الصوت، ضع مستوى صوت افتراضي
                              _settingsNotifier.updateVolume(0.5);
                            } else {
                              // إذا تم إلغاء الصوت، ضع المستوى على صفر
                              _settingsNotifier.updateVolume(0.0);
                            }
                            _saveSettings();
                          },
                        ),
                        _SettingsTile.sliderTile(
                          icon: Icons.volume_up_outlined,
                          title: 'Notification Volume',
                          subtitle: 'Adjust sound volume',
                          value: settings.notificationVolume,
                          enabled: settings.notificationsEnabled &&
                              settings.notificationVolume > 0.0,
                          onChanged: (value) {
                            _settingsNotifier.updateVolume(value);
                            _saveSettings();
                          },
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
      ),
    );
  }

  // إضافة دالة لفتح رابط الدفع
  Future<void> _launchPaymentURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // فتح في المتصفح الخارجي
        );

        // إظهار رسالة للمستخدم
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment page opened in browser'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open payment page'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening payment page: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.pushNamed(context, '/change_password');
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyPage(),
      ),
    );
  }

  void _openTerms() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsConditionsPage(),
      ),
    );
  }
}

// Wallet Section Widget
class _WalletSection extends StatelessWidget {
  final String centerId;
  static const Color customBlue = Color(0xFF1B4965);

  const _WalletSection({required this.centerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return _SettingsSection(
          title: 'Wallet',
          children: [
            // Wallet Balance Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        customBlue,
                        customBlue.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Wallet Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (state is SettingWalletLoaded) ...[
                        Text(
                          '${state.wallet.balance.toString()} EGP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else if (state is SettingLoading) ...[
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ] else if (state is SettingError) ...[
                        const Text(
                          'Error loading balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          '0.00 EGP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Recharge Button
            _SettingsTile.navigationTile(
              icon: Icons.add_card,
              title: 'Recharge Wallet',
              subtitle: 'Add funds to your wallet',
              onTap: () => _showRechargeDialog(context),
            ),

            // Transaction History
            _SettingsTile.navigationTile(
              icon: Icons.history,
              title: 'Transaction History',
              subtitle: 'View your payment history',
              onTap: () => _showTransactionHistory(context),
            ),
          ],
        );
      },
    );
  }

  void _showRechargeDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recharge Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (EGP)',
                hintText: 'Enter amount to recharge',
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment page will open in your browser',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.pop(context),
              context.read<SettingCubit>().getWalletBalance(centerId),
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: customBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final amount = int.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context);
                context.read<SettingCubit>().initiatePayment(centerId, amount);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('Recharge'),
          ),
        ],
      ),
    );
  }

  void _showTransactionHistory(BuildContext context) {
    context.read<SettingCubit>().getWalletHistory(centerId);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Transaction History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SettingCubit, SettingState>(
                  builder: (context, state) {
                    if (state is WalletHistoryLoaded) {
                      return ListView.builder(
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = state.transactions[index];
                          return ListTile(
                            leading: Icon(
                              transaction.type == 'credit'
                                  ? Icons.add_circle
                                  : Icons.remove_circle,
                              color: transaction.type == 'credit'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text('${transaction.amount} EGP'),
                            subtitle: Text(transaction.reason ?? 'Transaction'),
                            trailing: Text(
                              transaction.createdAt.toString().split(' ')[0],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      );
                    } else if (state is SettingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SettingError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('No transactions found'));
                  },
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                  context.read<SettingCubit>().getWalletBalance(centerId)
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Deadline Section Widget
class _DeadlineSection extends StatelessWidget {
  final int urgentDeadlineHours;
  final int normalDeadlineHours;
  final ValueChanged<int> onUrgentChanged;
  final ValueChanged<int> onNormalChanged;

  const _DeadlineSection({
    required this.urgentDeadlineHours,
    required this.normalDeadlineHours,
    required this.onUrgentChanged,
    required this.onNormalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: 'Report Deadlines',
      children: [
        _SettingsTile.dropdownTile(
          icon: Icons.flash_on,
          title: 'Urgent Cases Deadline',
          value: '$urgentDeadlineHours hours',
          items: const [
            '1 hours',
            '2 hours',
            '3 hours',
            '4 hours',
            '6 hours',
            '12 hours'
          ],
          onChanged: (value) {
            final hours = int.parse(value.split(' ')[0]);
            onUrgentChanged(hours);
          },
        ),
        _SettingsTile.dropdownTile(
          icon: Icons.schedule,
          title: 'Normal Cases Deadline',
          value: '$normalDeadlineHours hours',
          items: const ['12 hours', '24 hours', '48 hours', '72 hours'],
          onChanged: (value) {
            final hours = int.parse(value.split(' ')[0]);
            onNormalChanged(hours);
          },
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String role;
  static const Color customBlue = Color(0xFF1B4965);

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
        backgroundColor: customBlue.withOpacity(0.2),
        backgroundImage:
            imageUrl?.isNotEmpty == true ? NetworkImage(imageUrl!) : null,
        child: imageUrl?.isEmpty != false
            ? Text(
                displayInitials,
                style: const TextStyle(
                  color: customBlue,
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
      style: FilledButton.styleFrom(
        backgroundColor: customBlue.withOpacity(0.2),
        foregroundColor: customBlue,
      ),
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainScaffold.fromString(role: role, initialIndex: 10),
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
  static const Color customBlue = Color(0xFF1B4965);

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
                  color: customBlue,
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
  static const Color customBlue = Color(0xFF1B4965);

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
        activeColor: customBlue,
        onChanged: onChanged,
      ),
    );
  }

  factory _SettingsTile.sliderTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required double value,
    bool enabled = true,
    required ValueChanged<double> onChanged,
  }) {
    return _SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: SizedBox(
        width: 150,
        child: Slider.adaptive(
          value: value,
          activeColor: customBlue,
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
        dropdownColor: Colors.white,
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
  final int urgentDeadlineHours;
  final int normalDeadlineHours;

  const _SettingsState({
    this.notificationsEnabled = true,
    this.notificationVolume = 0.5,
    this.urgentDeadlineHours = 2,
    this.normalDeadlineHours = 24,
  });

  _SettingsState copyWith({
    bool? notificationsEnabled,
    double? notificationVolume,
    int? urgentDeadlineHours,
    int? normalDeadlineHours,
  }) {
    return _SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationVolume: notificationVolume ?? this.notificationVolume,
      urgentDeadlineHours: urgentDeadlineHours ?? this.urgentDeadlineHours,
      normalDeadlineHours: normalDeadlineHours ?? this.normalDeadlineHours,
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

  void updateUrgentDeadline(int hours) {
    value = value.copyWith(urgentDeadlineHours: hours);
  }

  void updateNormalDeadline(int hours) {
    value = value.copyWith(normalDeadlineHours: hours);
  }

  void updateSettings({
    bool? notificationsEnabled,
    double? notificationVolume,
    int? urgentDeadlineHours,
    int? normalDeadlineHours,
  }) {
    value = value.copyWith(
      notificationsEnabled: notificationsEnabled,
      notificationVolume: notificationVolume,
      urgentDeadlineHours: urgentDeadlineHours,
      normalDeadlineHours: normalDeadlineHours,
    );
  }
}
