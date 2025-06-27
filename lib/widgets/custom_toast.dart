// advanced_notification.dart - Updated version
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Notifications/formatNotificationDate.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';
import 'package:shared_preferences/shared_preferences.dart'; // إضافة للحفظ المحلي

enum NotificationType { success, error, warning, info, notify }

enum AnimationStyle {
  slide,
  fade,
  glass,
  card,
  toast,
  notify,
}

class AdvancedNotification extends StatelessWidget {
  final String message;
  final String? title;
  final NotificationType type;
  final Duration duration;
  final VoidCallback? onTap;
  final Widget? leadingIcon;
  final Widget? trailingAction;
  final bool showProgress;
  final AnimationStyle animationStyle;
  final String? image;
  final String? sound;
  final DateTime? date;
  final Icon? icon;

  static late BuildContext _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext getContext() {
    return _context;
  }

  const AdvancedNotification({
    Key? key,
    required this.message,
    this.title,
    this.type = NotificationType.info,
    this.duration = const Duration(seconds: 3),
    this.onTap,
    this.leadingIcon,
    this.trailingAction,
    this.showProgress = false,
    this.animationStyle = AnimationStyle.slide,
    this.image,
    this.sound,
    this.date,
    this.icon,
  }) : super(key: key);

  Color get backgroundColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green.shade50;
      case NotificationType.error:
        return Colors.red.shade50;
      case NotificationType.warning:
        return Colors.amber.shade50;
      case NotificationType.info:
      case NotificationType.notify:
        return Colors.blue.shade50;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.amber;
      case NotificationType.info:
      case NotificationType.notify:
        return Colors.blue;
    }
  }

  IconData get defaultIcon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.notify:
        return Icons.notifications_none;
    }
  }

  // دالة للتحقق من إعدادات الصوت
  Future<bool> _shouldPlaySound() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;
      final notificationVolume = prefs.getDouble('notification_volume') ?? 0.5;

      // إذا كانت الإشعارات مقفولة أو الصوت صفر، لا تشغل الصوت
      return notificationsEnabled && notificationVolume > 0.0;
    } catch (e) {
      // في حالة وجود خطأ، شغل الصوت افتراضياً
      return true;
    }
  }

  // دالة للحصول على مستوى الصوت
  Future<double> _getVolumeLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('notification_volume') ?? 0.5;
    } catch (e) {
      return 0.5; // القيمة الافتراضية
    }
  }

  void show(BuildContext context) async {
    // التحقق من إعدادات الصوت قبل تشغيله
    final shouldPlaySound = await _shouldPlaySound();

    if (shouldPlaySound) {
      try {
        final player = AudioPlayer();
        final volume = await _getVolumeLevel();

        // ضبط مستوى الصوت
        await player.setVolume(volume);

        // تشغيل الصوت
        await player.play(AssetSource('sounds/notification.mp3'));
      } catch (e) {
        // في حالة فشل تشغيل الصوت، لا تفعل شيئاً
        print('Failed to play notification sound: $e');
      }
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = _buildStyled(context);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar _buildStyled(BuildContext context) {
    switch (animationStyle) {
      case AnimationStyle.fade:
        return _buildMaterialSnackBar(context);
      case AnimationStyle.slide:
        return _buildMaterialSnackBar(context);
      case AnimationStyle.glass:
        return _buildGlassmorphismSnackBar(context);
      case AnimationStyle.card:
        return _buildCardStyleSnackBar(context);
      case AnimationStyle.toast:
        return _buildToastStyleSnackBar(context);
      case AnimationStyle.notify:
        return _buildNotifyCard(context);
    }
  }

  SnackBar _buildMaterialSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: iconColor.withOpacity(0.3), width: 1),
      ),
      content: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            leadingIcon ?? Icon(defaultIcon, color: iconColor),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: iconColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingAction != null) ...[
              SizedBox(width: 8),
              trailingAction!,
            ],
          ],
        ),
      ),
      duration: duration,
      action: showProgress
          ? SnackBarAction(
              label: '',
              textColor: Colors.transparent,
              onPressed: () {},
              disabledTextColor: Colors.transparent,
            )
          : null,
    );
  }

  SnackBar _buildGlassmorphismSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.2),
                  iconColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: iconColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: leadingIcon ?? Icon(defaultIcon, color: iconColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) ...[
                          Text(
                            title!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                        Text(
                          message,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailingAction != null) ...[
                    SizedBox(width: 8),
                    trailingAction!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      duration: duration,
    );
  }

  SnackBar _buildCardStyleSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: leadingIcon ??
                      Icon(defaultIcon, color: iconColor, size: 30),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingAction != null) ...[
                SizedBox(width: 8),
                trailingAction!,
              ] else ...[
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black45),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      duration: duration,
    );
  }

  SnackBar _buildToastStyleSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: type == NotificationType.success
              ? Colors.green.shade400
              : type == NotificationType.error
                  ? Colors.red.shade400
                  : type == NotificationType.warning
                      ? Colors.amber.shade700
                      : Colors.blue.shade600,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon ?? Icon(defaultIcon, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (trailingAction != null) ...[
                SizedBox(width: 8),
                trailingAction!,
              ],
            ],
          ),
        ),
      ),
      duration: duration,
    );
  }

  SnackBar _buildNotifyCard(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20,
        right: 20,
        left: 20,
      ),
      content: Align(
        alignment: Alignment.bottomRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            minHeight: 100,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (image != null && image!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          image!,
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                        ),
                      )
                    else if (icon != null)
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: icon),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null && title!.isNotEmpty)
                            Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          if (title != null && title!.isNotEmpty)
                            const SizedBox(height: 2),
                          Text(
                            message,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatNotificationDate(date ?? DateTime.now()),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

void showAdvancedNotification(
  BuildContext context, {
  required String message,
  String? title,
  NotificationType type = NotificationType.info,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onTap,
  Widget? leadingIcon,
  Widget? trailingAction,
  bool showProgress = false,
  AnimationStyle style = AnimationStyle.card,
  String? image,
  String? sound,
  DateTime? date,
  Icon? icon,
}) {
  AdvancedNotification(
    message: message,
    title: title,
    type: type,
    duration: duration,
    onTap: onTap,
    leadingIcon: leadingIcon,
    trailingAction: trailingAction,
    showProgress: showProgress,
    animationStyle: style,
    image: image,
    sound: sound,
    date: date ?? DateTime.now(),
    icon: icon,
  ).show(context);
  final scaffoldState = context.findAncestorStateOfType<MainScaffoldState>();

  context.read<NotificationCubit>().loadNotifications(
        context.read<CenterCubit>().state,
      );
  scaffoldState?.reloadNotifyIcon();
}

// كلاس مساعد لإدارة إعدادات الصوت
class NotificationSoundManager {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationVolumeKey = 'notification_volume';

  // حفظ إعدادات الإشعارات
  static Future<void> saveNotificationSettings({
    required bool enabled,
    required double volume,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsEnabledKey, enabled);
      await prefs.setDouble(_notificationVolumeKey, volume);
    } catch (e) {
      print('Failed to save notification settings: $e');
    }
  }

  // جلب إعدادات الإشعارات
  static Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'enabled': prefs.getBool(_notificationsEnabledKey) ?? true,
        'volume': prefs.getDouble(_notificationVolumeKey) ?? 0.5,
      };
    } catch (e) {
      return {'enabled': true, 'volume': 0.5};
    }
  }

  // التحقق من إمكانية تشغيل الصوت
  static Future<bool> canPlaySound() async {
    final settings = await getNotificationSettings();
    return settings['enabled'] == true && settings['volume'] > 0.0;
  }

  // الحصول على مستوى الصوت
  static Future<double> getVolume() async {
    final settings = await getNotificationSettings();
    return settings['volume'] ?? 0.5;
  }
}
