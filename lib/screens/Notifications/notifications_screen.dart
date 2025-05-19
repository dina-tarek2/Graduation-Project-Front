import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_cubit.dart';
import 'package:graduation_project_frontend/cubit/Notification/notification_state.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/Notifications/formatNotificationDate.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String searchQuery = '';
  String filter = 'All'; // All, Read, Unread

  // GlobalKey to track the position of a widget
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final role = context.read<UserCubit>().state;
    final userId = context.read<CenterCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title:
            const Text('Notifications', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScaffold(role: role)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.green),
            tooltip: 'Mark all as Read',
            onPressed: () {
              BlocProvider.of<NotificationCubit>(context)
                  .markAllNotificationsAsRead(userId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            tooltip: 'Delete all Notifications',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete All'),
                  content: const Text(
                      'Are you sure you want to delete all notifications?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete')),
                  ],
                ),
              );
              if (confirm == true) {
                BlocProvider.of<NotificationCubit>(context)
                    .deleteAllNotifications(userId);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search by Title or Message',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChipWidget(
                    label: 'All',
                    selected: filter == 'All',
                    color: Colors.grey.shade300,
                    onTap: () => setState(() => filter = 'All'),
                  ),
                  const SizedBox(width: 6),
                  FilterChipWidget(
                    label: 'Unread',
                    selected: filter == 'Unread',
                    color: lightBlue,
                    onTap: () => setState(() => filter = 'Unread'),
                  ),
                  const SizedBox(width: 6),
                  FilterChipWidget(
                    label: 'Read',
                    selected: filter == 'Read',
                    color: Colors.green.shade200,
                    onTap: () => setState(() => filter = 'Read'),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationLoaded) {
                    var notifications = state.notifications;

                    // Apply search filter
                    notifications = notifications
                        .where((n) =>
                            n.title
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            n.message
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                        .toList();

                    // Apply read/unread filter
                    if (filter == 'Read') {
                      notifications =
                          notifications.where((n) => n.isRead).toList();
                    } else if (filter == 'Unread') {
                      notifications =
                          notifications.where((n) => !n.isRead).toList();
                    }

                    if (notifications.isEmpty) {
                      return const Center(
                          child: Text('No notifications found.'));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        return Dismissible(
                            key: Key(notification.id.toString()), // Unique key
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content:
                                      const Text('Delete this notification?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel')),
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete')),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (_) {
                              BlocProvider.of<NotificationCubit>(context)
                                  .deleteNotification(notification.id);
                            },
                            child: GestureDetector(
                              onTap: () {
                                BlocProvider.of<NotificationCubit>(context)
                                    .markAsRead(index, userId);
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: notification.isRead
                                    ? Colors.white70
                                    : Colors.blue
                                        .shade50, // استخدام darkBlue للـ Unread و sky للـ Read
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.blueAccent.withOpacity(0.1),
                                        backgroundImage:
                                            NetworkImage(notification.icon),
                                        radius: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    notification.title,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkBlue
                                                          // لون النص عند القراءة
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  notification.isRead
                                                      ? Icons
                                                          .mark_email_read_outlined
                                                      : Icons
                                                          .mark_email_unread_outlined,
                                                  color: notification.isRead
                                                      ? Colors.green
                                                      : blue, // تغيير الأيقونة لـ Unread أو Read
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              notification.message,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:grey // تغيير النص للقراءة/الغير مقروء
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.access_time_filled,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  notification.createdAt != null
                                                      ? formatNotificationDate(
                                                          notification
                                                              .createdAt!)
                                                      : '-',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors
                                                        .grey, // لون الوقت
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                const Text(
                                                  "Scrolling Right to delete",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        0x86000000), // تعليمات الحذف
                                                  ),
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
                            ));
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No notifications available.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? color : Colors.grey.shade200,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? Colors.black26 : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
