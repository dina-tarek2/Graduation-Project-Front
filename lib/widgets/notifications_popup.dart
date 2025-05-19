import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Notifications/formatNotificationDate.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';
import 'package:intl/intl.dart';

class NotificationsPopup extends StatefulWidget {
  static const String id = "NotificationsPopup";
  const NotificationsPopup({super.key});

  @override
  State<NotificationsPopup> createState() => _NotificationsPopupState();
}

class _NotificationsPopupState extends State<NotificationsPopup> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = context.read<CenterCubit>().state;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().loadNotifications(userId);
    });
  }

  Color getNotificationColor(String? type, bool isRead) {
    if (isRead) return Colors.grey.shade200;
    switch (type) {
      case 'error':
        return Colors.red.shade50;
      case 'success':
        return Colors.green.shade50;
      case 'info':
      default:
        return Colors.blue.shade50;
    }
  }

  Icon getNotificationIcon(String? type, bool isRead) {
    if (isRead) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    }
    switch (type) {
      case 'error':
        return const Icon(Icons.error_outline, color: Colors.red, size: 20);
      case 'success':
        return const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 20);
      case 'info':
      default:
        return const Icon(Icons.notifications_active, color: blue, size: 20);
    }
  }

  Color getTimeTextColor(String? type) {
    switch (type) {
      case 'error':
        return Colors.red;
      case 'success':
        return Colors.green;
      case 'info':
      default:
        return blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: darkblue,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is NotificationLoaded) {
                  final notifications = state.notifications;

                  if (notifications.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No notifications available'),
                    );
                  }

                  return Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: notifications.length.clamp(0, 4),
                        separatorBuilder: (_, __) => Divider(height: 1),
                        // physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final n = notifications[index];
                          final formattedDate =
                              formatNotificationDate(n.createdAt!);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: getNotificationColor('info', n.isRead),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              title: Text(
                                n.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n.message,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  Tooltip(
                                    message: DateFormat('yyyy-MM-dd – HH:mm')
                                        .format(n.createdAt!),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: getTimeTextColor('info'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: getNotificationIcon('info', n.isRead),
                              onTap: () {
                                if (!n.isRead) {
                                  context
                                      .read<NotificationCubit>()
                                      .markAsRead(index,userId);
                                }
                              },
                            ),
                          );
                        },
                      ),
                      if (notifications.length > 4)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'You have more notifications...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                } else if (state is NotificationError) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('Failed to load notifications')),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No notifications available')),
                  );
                }
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => MainScaffold(
                          role: context.read<UserCubit>().state,
                          Index: 11,
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('View All'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
