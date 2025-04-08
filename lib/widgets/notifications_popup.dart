import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Notifications/notifications_screen.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class NotificationsPopup extends StatelessWidget {
  static const String id = "NotificationsPopup";
  const NotificationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain userId from CenterCubit
    final String userId = context.read<CenterCubit>().state;

    // Ensure notifications are loaded after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().loadNotifications(userId);
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 280, // ✅ تحديد العرض يمنع الخطأ
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            // ✅ عشان يمنع overflow لو زاد المحتوى
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: darkblue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is NotificationLoaded) {
                      final notifications = state.notifications;

                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: notifications.length.clamp(0, 4),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: notification.isRead
                                  ? Colors.white // Light background if read
                                  : Colors.yellow
                                      .shade100, // Darker background if unread
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                title: Text(
                                  notification.title,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  notification.message,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: notification.isRead
                                    ? const Icon(Icons.check,
                                        color: Colors.green, size: 16)
                                    : const Icon(Icons.notifications, size: 16),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is NotificationError) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child:
                            Center(child: Text('Failed to load notifications')),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child:
                            Center(child: Text('No notifications available')),
                      );
                    }
                  },
                ),
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoaded &&
                        state.notifications.length > 4) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 12),
                        child: Text(
                          'You have more notifications.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                // زر View All داخل الـ Dialog
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => MainScaffold(
                              role: context.read<UserCubit>().state,
                              Index: 11), // مثلاً 2 للإشعارات
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View All'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
