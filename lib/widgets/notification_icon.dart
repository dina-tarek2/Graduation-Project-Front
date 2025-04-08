import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';


class otificationIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return CircularProgressIndicator();
        } else if (state is NotificationLoaded) {
          final notifications = state.notifications;
          final unreadCount =
              notifications.where((notif) => !notif.isRead).length;

          return IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // عند الضغط على الأيقونة، يتم الانتقال إلى شاشة الإشعارات
              Navigator.pushNamed(context, '/notifications');
            },
          );
        } else if (state is NotificationError) {
          return Icon(Icons.notifications_off);
        } else {
          return Icon(Icons.notifications_none);
        }
      },
    );
  }
}
