import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Notifications/formatNotificationDate.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final role = context.read<UserCubit>().state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScaffold(role: role)),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: Text(
                  'No notifications available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<NotificationCubit>(context)
                        .markAsRead(index);
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: notification.isRead
                        ? Colors.white // Light background if read
                        : Colors.yellow.shade100, // Darker background if unread
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            backgroundImage: NetworkImage(notification.icon),
                            radius: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      notification.isRead
                                          ? Icons.mark_email_read_outlined
                                          : Icons.mark_email_unread_outlined,
                                      color: notification.isRead
                                          ? Colors.green
                                          : Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification.message,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      notification.createdAt != null
                                          ? formatNotificationDate(
                                              notification.createdAt!)
                                          : '-',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NotificationError) {
            return const Center(child: Text('Failed to fetch notifications'));
          } else {
            return const Center(child: Text('No notifications available'));
          }
        },
      ),
    );
  }
}
