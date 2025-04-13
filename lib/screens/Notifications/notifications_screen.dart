import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final role = context.read<UserCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MainScaffold(role: role)),
                    );
                  },
                ),
              ),
            ),

            // Search + Filter Row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search by Name or ID',
                        prefixIcon: Icon(Icons.search),
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
                  // Filter Chips
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
                    color: Colors.orange.shade200,
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

            // Notifications
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

                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<NotificationCubit>(context)
                                .markAsRead(index);
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: notification.isRead
                                ? Colors.white
                                : Colors.yellow.shade100,
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
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
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
                                                  : Colors.orangeAccent,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          notification.message,
                                          style: const TextStyle(fontSize: 14),
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
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No notifications available'));
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
